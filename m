From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: cifs: Split lanman auth from CIFS_SessSetup()
Date: Mon, 14 Jul 2014 17:02:30 +0100
Message-ID: <1405353750.11726.24.camel@sachin-laptop>
References: <20140707114126.GA21109@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140707114126.GA21109@mwanda>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 2014-07-07 at 14:41 +0300, Dan Carpenter wrote:
> Hello Sachin Prabhu,
> 
> The patch 4b26c7b1fc36: "cifs: Split lanman auth from
> CIFS_SessSetup()" from Jun 16, 2014, leads to the following static
> checker warning:
> 
> 	fs/cifs/sess.c:797 CIFS_SessSetup()
> 	warn: possible memory leak of 'sess_data'
> 
> fs/cifs/sess.c
>    784          sess_data = kzalloc(sizeof(struct sess_data), GFP_KERNEL);
>    785          if (!sess_data)
>    786                  return -ENOMEM;
>    787          sess_data->xid = xid;
>    788          sess_data->ses = ses;
>    789          sess_data->buf0_type = CIFS_NO_BUFFER;
>    790          sess_data->nls_cp = (struct nls_table *) nls_cp;
>    791  
>    792          type = select_sectype(ses->server, ses->sectype);
>    793          cifs_dbg(FYI, "sess setup type %d\n", type);
>    794          if (type == Unspecified) {
>    795                  cifs_dbg(VFS,
>    796                          "Unable to select appropriate authentication method!");
>    797                  return -EINVAL;
>                         ^^^^^^^^^^^^^^
> missing kfree().
> 
>    798          }
> 
> regards,
> dan carpenter
> --

Hello Dan,

This is indeed a bug. This was however fixed in a patch which came in
later in the series. This patch replaces CIFS_SessSetup(). 
https://git.samba.org/?p=sfrench/cifs-2.6.git;a=commit;h=f877b1fa0ebe6074694721562072106d542e44e1

It looks like the patch wasn't included in Steve's test tree when you
ran your tests. I believe we no longer require a fix for this particular
issue in Steve's tree which now contains the entire series.

Sachin Prabhu
