From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/2] cifs: Add attribute read/write support to SMB2+
Date: Sun, 27 Aug 2017 17:02:30 -0500
Message-ID: <CAH2r5msH-r0=Nk9JC0Xx1cXBLYd+PLN0GyRqq1T25NZRd7VwAA@mail.gmail.com>
References: <20170824012456.10977-1-lsahlber@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170824012456.10977-1-lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged into cifs-2.6.git for-next

On Wed, Aug 23, 2017 at 8:24 PM, Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Tested against both Samba shares as well as Win7 shares.
>
> Version 5:
> * Learn how to use endianness macros correctly.
>
> Version 4:
> * Remove remaining CamelCase
> * ea_value_length is __le16, not __u16
>
> Version 3:
> * No CamelCase in new code.
> * No declarations inside loops.
>
> Version 2:
> * For reading attributes we need FILE_READ_EA not FILE_READ_ATTRIBUTES
>



-- 
Thanks,

Steve
