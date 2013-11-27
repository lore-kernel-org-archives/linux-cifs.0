From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 8/8] cifs: Add support for readlink on dfs shares under
 posix extensions
Date: Wed, 27 Nov 2013 09:10:01 -0800
Message-ID: <20131127171001.GA3149@infradead.org>
References: <1385399395-19217-1-git-send-email-sprabhu@redhat.com>
 <1385399395-19217-9-git-send-email-sprabhu@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1385399395-19217-9-git-send-email-sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I was going to complain that no filesystem should implement readlink
itself but use the generic wrappers around ->follow_link, but it turns
our you actually do implement follow_link through that query_link
API.

Please fix the subject, though.
