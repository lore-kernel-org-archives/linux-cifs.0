From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] consistently use smb_buf_length as be32 for cifs
Date: Thu, 17 Mar 2011 09:38:22 -0500
Message-ID: <AANLkTi=PvS9vBn1fkQPt3F8gjzB4G9xTXiWXiMczxnkp@mail.gmail.com>
References: <AANLkTimnfO=GnKC6GK6FZ+H-hfchWhW=HzcUS+HcLH+c@mail.gmail.com>
	<20110317142925.GA3295@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110317142925.GA3295-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Mar 17, 2011 at 9:29 AM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> =
wrote:
>> - =A0 =A0 pSMB->hdr.smb_buf_length +=3D count;
>> + =A0 =A0 update_rfc1001_len(pSMB, count);
>
> The helper is very confusingly named relatively to the field it updat=
es,
> moreover we already have nice helpers to do arithmetics on big endian
> fields. =A0These can just become:
>
> =A0 =A0 =A0 =A0be32_add_cpu(&pSMB->hdr.smb_buf_length, count);

ok - will change those.



--=20
Thanks,

Steve
