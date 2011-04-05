From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 5/5] cifs: clean up various nits in unicode routines
Date: Tue, 05 Apr 2011 19:01:18 +0100
Message-ID: <7882.1302026478@redhat.com>
References: <7828.1302026339@redhat.com> <20110405103209.75fb7da5@corrin.poochiereds.net> <1301607405-4379-1-git-send-email-jlayton@redhat.com> <1301607405-4379-6-git-send-email-jlayton@redhat.com> <BANLkTino1a1Wr55BCynPGK176Zbm5DPcXw@mail.gmail.com>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7828.1302026339-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> Which line is it that actually gives the warning?  Is it when 0 is implicitly
> cast to __le16?  If so, can you just cast it directly?

Actually, if it really *is* that line, then perhaps *sparse* is wrong... (0 is
special after all).

David
