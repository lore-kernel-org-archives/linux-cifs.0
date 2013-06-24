From: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH] [CIFS] SMB2 FSCTL and IOCTL worker function
Date: Mon, 24 Jun 2013 15:35:57 +0200
Message-ID: <20130624153557.2b4081ae@f163.suse.de>
References: <CAH2r5muUxsPGg6VoiykMx-YiT=zyiF5tfgfs6j2U++KoGVCP+A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5muUxsPGg6VoiykMx-YiT=zyiF5tfgfs6j2U++KoGVCP+A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Steve,

On Mon, 24 Jun 2013 02:19:13 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> +	rc = SendReceive2(xid, ses, iov, num_iovecs, &resp_buftype, 0);
> +	rsp = (struct smb2_ioctl_rsp *)iov[0].iov_base;
> +
> +	if (rc != 0) {
> +		if (tcon)
> +			cifs_stats_fail_inc(tcon, SMB2_IOCTL_HE);
> +		goto ioctl_exit;
> +	}

IIUC, this throws away any response data if the server reply status
is unsuccessful.

The caller may wish to obtain the response data under certain error
conditions, particularly in the case of FSCTL_SRV_COPYCHUNK, where the
server returns chunk request limits alongside STATUS_INVALID_PARAMETER
in some cases. See MS-SMB2 2.2.32.1 for details.

Cheers, David
