From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 5/9] fallback to CIFSSMBQPathInfoBasic() in
 cifs_is_path_accessible()
Date: Fri, 22 Nov 2013 06:35:46 -0800
Message-ID: <20131122143546.GA27665@infradead.org>
References: <E1VjSnS-004B9V-Fo@intern.SerNet.DE>
 <1385116018-14068-1-git-send-email-gbeck@sernet.de>
 <1385116018-14068-6-git-send-email-gbeck@sernet.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gregor Beck <gbeck-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1385116018-14068-6-git-send-email-gbeck-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Please provide a helper that encapsulates the calls for the different
info levels, and then formats them into a in-kernel sanitized structure
instead of casting around the on the wire structures, similar to how
the directory code translates that various info levels in a cifs_dirent
structure.
