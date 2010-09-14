From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: fix potential double put of TCP session reference
Date: Tue, 14 Sep 2010 07:39:54 -0400
Message-ID: <20100914073954.5c818d3c@corrin.poochiereds.net>
References: <1284400930-24134-1-git-send-email-jlayton@redhat.com>
	<4C8F44F0.30803@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C8F44F0.30803-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 14 Sep 2010 15:18:32 +0530
Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:

> On 09/13/2010 11:32 PM, Jeff Layton wrote:
> > cifs_get_smb_ses must be called on a server pointer on which it holds an
> > active reference. It first does a search for an existing SMB session. If
> > it finds one, it'll put the server reference and then try to ensure that
> > the negprot is done, etc.
> > 
> > If it encounters an error at that point then it'll return an error.
> > There's a potential problem here though. When cifs_get_smb_ses returns
> > an error, the caller will also put the TCP server reference leading to a
> > double-put.
> > 
> > Fix this by having cifs_get_smb_ses only put the server reference if
> > it found an existing session that it could use and isn't returning an
> > error.
> > 
> > Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> >  fs/cifs/connect.c |    6 +++---
> >  1 files changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> > index 67dad54..88c84a3 100644
> > --- a/fs/cifs/connect.c
> > +++ b/fs/cifs/connect.c
> > @@ -1706,9 +1706,6 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb_vol *volume_info)
> >  	if (ses) {
> >  		cFYI(1, "Existing smb sess found (status=%d)", ses->status);
> >  
> > -		/* existing SMB ses has a server reference already */
> > -		cifs_put_tcp_session(server);
> > -
> >  		mutex_lock(&ses->session_mutex);
> >  		rc = cifs_negotiate_protocol(xid, ses);
> >  		if (rc) {
> > @@ -1731,6 +1728,9 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb_vol *volume_info)
> >  			}
> >  		}
> >  		mutex_unlock(&ses->session_mutex);
> > +
> > +		/* existing SMB ses has a server reference already */
> > +		cifs_put_tcp_session(server);
> >  		FreeXid(xid);
> >  		return ses;
> >  	}
> 
> Looks correct to me.
> 
> Reviewed-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>

Thanks. In hindsight, I should have probably sent this to stable too.

Steve, would you like me to resend and cc stable? We probably want this
in 2.6.36 too, if possible.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
