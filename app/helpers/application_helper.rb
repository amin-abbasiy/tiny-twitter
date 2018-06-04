module ApplicationHelper
    def full_title(page_title = '')
        base_title = "Amin Is Best"
        if page_title.empty? then
            return base_title
        else
            return page_title + ' | ' + base_title
        end
    end
end
