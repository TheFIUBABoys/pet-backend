namespace :doc do
  desc "Generates api doc in /api_doc folder"
  task api: :environment do
    `raml2html api_doc/doc.raml > api_doc/doc.html`
  end
end
