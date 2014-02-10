require_relative '../feed'

class JCloudsJiraFeed < Feed
  register "https://issues.apache.org/jira/sr/jira.issueviews:searchrequest-rss/temp/SearchRequest.xml?jqlQuery=project+%3D+JCLOUDS&tempMax=100"

  KEYWORDS = %w{rackspace openstack}

  def items
    super.select do |item|
      downcased = item.body.downcase + item.title.downcase
      KEYWORDS.any? { |word| downcased.include? word }
    end
  end
end
