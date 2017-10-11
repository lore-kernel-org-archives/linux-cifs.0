From: =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix NULL pointer deref on TCON failures
Date: Wed, 11 Oct 2017 13:23:08 +0200
Message-ID: <mps376q9bdv.fsf@aaptelpc.suse.de>
References: <20171010230138.31832-1-lsahlber@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171010230138.31832-1-lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Wah! I believe we worked on the exact same bug. I was just about to send
a similar patch (coming up).

The difference is the code still goes thru the block that sets the
reconnect flag, which we should do I think.

>	rsp = (struct smb2_tree_connect_rsp *)rsp_iov.iov_base;
>
>	if (rc != 0) {
>		if (tcon) {
>			cifs_stats_fail_inc(tcon, SMB2_TREE_CONNECT_HE);
>			tcon->need_reconnect = true;
>		}
>		goto tcon_error_exit;
>	}

this block ^^^^^

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
