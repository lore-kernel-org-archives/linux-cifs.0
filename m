From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: smatch stuff: dereferencing first then checking in SendReceive()
Date: Sat, 19 Mar 2011 22:20:24 -0500
Message-ID: <AANLkTikxrdGSmgvxEzTd1c9Czu3xb1UPd3x5jfdTHYjQ@mail.gmail.com>
References: <20110319232857.GA28096@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Dan Carpenter <error27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110319232857.GA28096@bicker>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, Mar 19, 2011 at 6:28 PM, Dan Carpenter <error27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrot=
e:
> Smatch complains about this, but I don't know if it's a bug or not.
>
> fs/cifs/transport.c +791 SendReceive(106)
> =A0 =A0 =A0 =A0warn: variable dereferenced before check 'midQ->resp_b=
uf'
>
> =A0 780 =A0 =A0 =A0 =A0 =A0receive_len =3D be32_to_cpu(midQ->resp_buf=
->smb_buf_length);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0^^^^^^^^^^^^^^^^
> =A0 =A0 =A0 =A0dereference
> =A0 781
> =A0 782 =A0 =A0 =A0 =A0 =A0if (receive_len > CIFSMaxBufSize + MAX_CIF=
S_HDR_SIZE) {
> =A0 783 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR(1, "Frame too large=
 received. =A0Length: %d =A0Xid: %d",
> =A0 784 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0receive_le=
n, xid);
> =A0 785 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -EIO;
> =A0 786 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
> =A0 787 =A0 =A0 =A0 =A0 =A0}
> =A0 788
> =A0 789 =A0 =A0 =A0 =A0 =A0/* rcvd frame is ok */
> =A0 790
> =A0 791 =A0 =A0 =A0 =A0 =A0if (midQ->resp_buf && out_buf
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^^^^^^^^^^
> =A0 =A0 =A0 =A0checking for null
>
> =A0 792 =A0 =A0 =A0 =A0 =A0 =A0 =A0&& (midQ->midState =3D=3D MID_RESP=
ONSE_RECEIVED)) {
> =A0 793 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0out_buf->smb_buf_length =3D=
 cpu_to_be32(receive_len);
>
> regards,
> dan carpenter

Older kernels had the same (midQ->resp_buf =3D=3D NULL)
check in the same place, and I don't see a way to get there with
midQ->resp_buf =3D=3D NULL so that check on line
791 does look redundant check.

I will double check.



--=20
Thanks,

Steve
