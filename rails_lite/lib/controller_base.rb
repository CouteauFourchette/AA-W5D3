require 'active_support'
require 'active_support/core_ext'
require 'active_support/inflector'
require 'erb'
require 'byebug'
require_relative './session'

class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res, params = {})
    @req = req
    @res = res
    @params = params.merge(req.params)

  end

  # Helper method to alias @built_reponse
  def already_built_response?
    @built_reponse
  end

  # Set the response status code and header
  def redirect_to(url)
    raise 'error two renders' if already_built_response?
    @built_reponse = true
    @res.status = 302
    @res.location = url
    session.store_session(@res)
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    raise 'error two renders' if already_built_response?
    @built_reponse = true
    @res['Content-Type'] = content_type
    @res.write(content)
    session.store_session(@res)
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    file = File.read("./views/#{self.class.name.underscore}/#{template_name}.html.erb")
    template = ERB.new(file)
    render_content(template.result(binding), 'text/html')
  end

  # method exposing a `Session` object
  def session
    @session ||= Session.new(@req)
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
    self.send(name)
    render(name) unless already_built_response?
  end
end
