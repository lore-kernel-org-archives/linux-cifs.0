From: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [[PATCH v2] [CIFS] Allow setting per-file compression via SMB2
 and SMB3
Date: Wed, 9 Oct 2013 00:25:45 +0200
Message-ID: <20131009002545.114ae8a5@plati.site>
References: <CAH2r5mubgNp_gY=0b_dWuQx2X2S1hESz5iKXwNhGZfXwCM7TsA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mubgNp_gY=0b_dWuQx2X2S1hESz5iKXwNhGZfXwCM7TsA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Steve,

On Tue, 8 Oct 2013 15:41:17 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> +			/* Currently only flag we can set is compressed flag */
> +			if ((ExtAttrBits & FS_COMPR_FL) == 0)
> +				break;
> +
> +			/* Try to set compress flag */
> +			if (tcon->ses->server->ops->set_compression) {
> +				rc = tcon->ses->server->ops->set_compression(
> +							xid, tcon, pSMBFile);
> +				cifs_dbg(FYI, "set compress flag rc %d\n", rc);
>  			}

Is the FileFsAttributeInformation known at this stage? If so, you may
wish to check for the FILE_FILE_COMPRESSION capability, and avoid the
request dispatch if absent.

IIRC, Explorer hides the compression check-checkbox if the capability
is missing.
