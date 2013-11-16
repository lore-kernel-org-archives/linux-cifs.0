From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: setfacl fix
Date: Sat, 16 Nov 2013 06:55:07 -0800
Message-ID: <20131116145507.GA22395@infradead.org>
References: <CAH2r5msswZg_NvY9qMNknh2FWht1jMgwW1s2umtaBj3mHreDAw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAH2r5msswZg_NvY9qMNknh2FWht1jMgwW1s2umtaBj3mHreDAw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Nov 15, 2013 at 08:53:12PM -0600, Steve French wrote:
> From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Date: Fri, 15 Nov 2013 20:41:32 -0600
> Subject: [PATCH] [CIFS] setfacl removes part of ACL when setting POSIX ACLs to
>  Samba
> 
> setfacl over cifs mounts can remove the default ACL when setting the
> (non-default part of) the ACL and vice versa (we were leaving at 0
> rather than setting to -1 the count field for the unaffected
> half of the ACL.  For example notice the setfacl removed
> the default ACL in this sequence:

Can you send a patch to xfstests to make sure we regression test for
this issue on all filesystems?
