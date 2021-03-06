class Entry < ActiveRecord::Base
  belongs_to :author
  has_many :user_applications

  def self.import_entries(file)
    file.css("entry").each do |entry_data|
      entry = Entry.find_or_create_by(posting_id: entry_data.css("id").inner_text)
      entry.update_attributes(published: entry_data.css("published").inner_text.to_datetime, 
         link: entry_data.css("link").attribute('href').value,
         title: entry_data.css("title").inner_text,
         content: entry_data.css("content").inner_text,
         author_id: Author.import_author(entry_data.css("author")))
    end
  end

  self.per_page = 30
 
  def self.search(collection, text)
    entries = collection.where("title LIKE '%#{text}%' OR content LIKE '%#{text}%'")
  end
end
