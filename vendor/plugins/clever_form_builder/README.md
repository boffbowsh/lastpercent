# CleverFormBuilder
Yet another form builder that we've been using in house at Rawnet. Doesn't do anything particularly special but
does support partials (both erb/haml), to replace the default simply create 'app/views/partials/_field.html.haml'.

## Example

### ERb
    <% clever_form_for(@post) do |f| %>
      <%= f.text_field :title %>
      <%= f.submit %>
    <% end %>


### HAML
    - clever_form_for(@post) do |f|
      = f.text_field :title
      = f.text_field :author
      = f.text_area :summary, :rows => 3
      = f.text_area :body
      = f.submit 'Save'


Copyright (c) 2009 Peter Lambert, released under the MIT license
