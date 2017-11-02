From: =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 01/19] cifs: Add SendReceive3
Date: Thu, 02 Nov 2017 15:14:26 +0100
Message-ID: <87o9okvkcd.fsf@suse.com>
References: <20171102070312.18903-1-lsahlber@redhat.com> <20171102070312.18903-2-lsahlber@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171102070312.18903-2-lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:
> +
> +	new_iov = kmalloc(sizeof(struct kvec) * (n_vec + 1), GFP_KERNEL);
> +	if (!new_iov)
> +		return -ENOMEM;
> +
> +	/* 1st iov is an RFC1002 Session Message length */
> +	memcpy(new_iov + 1, iov, (sizeof(struct kvec) * n_vec));
> +
> +	count = 0;
> +	for (i = 1; i < n_vec + 1; i++)
> +		count += new_iov[i].iov_len;
> +
> +	rfc1002_marker = cpu_to_be32(count);
> +
> +	new_iov[0].iov_base = &rfc1002_marker;
> +	new_iov[0].iov_len = 4;
> +
> +	memset(&rqst, 0, sizeof(struct smb_rqst));
> +	rqst.rq_iov = new_iov;
> +	rqst.rq_nvec = n_vec + 1;
> +
> +	rc = cifs_send_recv(xid, ses, &rqst, resp_buf_type, flags, resp_iov);
> +	kfree(new_iov);
> +	return rc;
> +}
> +

I know this is kind of unrelated but I've been thinking to myself we
should try to get rid of this dynamic allocation at some point.

IIUC the iovec never has more than a couple of elements, so we could
have something like a fixed sized stack allocated iovec array +
MAX_IOVEC_LENGTH macro.

Doing a kmalloc() for every packet defeats the purpose of the memory
pool optimization we use for small/large buffers.

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
