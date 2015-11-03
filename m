From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Send durable handle v2 contexts when use of persistent handles required
Date: Tue, 3 Nov 2015 09:56:03 -0600
Message-ID: <CAH2r5mtXuHDvKbJV9dcQcWpwaPnAdB0ebtdNm_uQXRkJMSFQ9Q@mail.gmail.com>
References: <20151103114729.GA18287@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151103114729.GA18287@mwanda>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Good catch.  Updating patch.

On Tue, Nov 3, 2015 at 5:47 AM, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> Hello Steve French,
>
> The patch ea81d9ba9d72: "Send durable handle v2 contexts when use of
> persistent handles required" from Oct 3, 2015, leads to the following
> static checker warning:
>
>         fs/cifs/smb2pdu.c:1156 create_durable_v2_buf()
>         warn: struct type mismatch 'create_durable_v2 vs create_durable'
>
> fs/cifs/smb2pdu.c
>   1151  static struct create_durable_v2 *
>   1152  create_durable_v2_buf(struct cifs_fid *pfid)
>   1153  {
>   1154          struct create_durable_v2 *buf;
>   1155
>   1156          buf = kzalloc(sizeof(struct create_durable), GFP_KERNEL);
>
> I think this is a problem, isn't create_durable_v2 larger?  Smatch is
> bad at calculating the sizes of enums.
>
>   1157          if (!buf)
>   1158                  return NULL;
>   1159
>
> regards,
> dan carpenter



-- 
Thanks,

Steve
