# helpersは自動的に全ビューに読み込まれる
module ApplicationHelper
    # ページごとの完全なタイトルを返す
    def full_title(page_title='')
        base_title = "Yourprotein App"
        if page_title.empty?
            base_title
        else
            page_title + " | " + base_title
        end
    end
end
