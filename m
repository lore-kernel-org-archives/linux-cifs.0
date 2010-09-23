From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 09/15] cifs: have cifsFileInfo hold a reference to a tlink
 rather than tcon pointer
Date: Thu, 23 Sep 2010 01:08:51 -0500
Message-ID: <AANLkTi=n=_R_WF8NizLo+zfcBEmzcQpBWWj=_GNEmua1@mail.gmail.com>
References: <1285023704-2159-1-git-send-email-jlayton@redhat.com>
	<1285023704-2159-10-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1285023704-2159-10-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Sep 20, 2010 at 6:01 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> cifsFileInfo needs a pointer to a tcon, but it doesn't currently hold a
> reference to it. Change it to keep a pointer to a tcon_link instead and
> hold a reference to it.

Nice work on these patches but they do end up more complex than I expected
(may be unavoidable).

Before committing the last set - are we sure that there is no way we could have
done the list of tids/uids off the same tcon or simplify.  For example (may be
impractical, but worth considering) - if we limited many of these changes to
init_smb itself - if in init_smb we see a request from local uid that does not
have an smb uid negotiated, we negotiate/sessionsetup/tcon
there (as we do reconnect today in some cases) to get the new tid - this does
have the problem of not knowing the uid of the opener of a file though so
perhaps not problem.

Your way may be better - but it is a much bigger change.

-- 
Thanks,

Steve
