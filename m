From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: AES Crypto Support in Kernel
Date: Mon, 6 May 2013 09:11:28 -0500
Message-ID: <CAH2r5muCod5S7PgRgD6CEbSwFtXykUmyP8fusRqLt-KLW1cMvQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Shirish S Pargaonkar <shirishp-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Shirish,
Does the recent crypto merge to kernel, which includes these two
patches for example, help you (at least on the more common chips,
those with optimized AES offload support)?  Wonder if we can leverage
the hardware offload in Samba?

commit c456a9cd1ac4eae9147ffd7ac4fb77ca0fa980c6
Author: Jussi Kivilinna <jussi.kivilinna-X3B1VOXEql0@public.gmane.org>
Date:   Mon Apr 8 21:51:16 2013 +0300

    crypto: aesni_intel - add more optimized XTS mode for x86-64

    Add more optimized XTS code for aesni_intel in 64-bit mode, for
smaller stack
    usage and boost for speed.

    tcrypt results, with Intel i5-2450M:
    256-bit key
            enc     dec
    16B     0.98x   0.99x
    64B     0.64x   0.63x
    256B    1.29x   1.32x
    1024B   1.54x   1.58x
    8192B   1.57x   1.60x
--
    performance is reduced in tcrypt for 64 byte long blocks.

    Cc: Huang Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
    Signed-off-by: Jussi Kivilinna <jussi.kivilinna-X3B1VOXEql0@public.gmane.org>
    Signed-off-by: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>

commit b5c5b072dc2f35d45d3404b957e264a3e8e71069
Author: Jussi Kivilinna <jussi.kivilinna-X3B1VOXEql0@public.gmane.org>
Date:   Mon Apr 8 21:51:11 2013 +0300

    crypto: x86/camellia-aesni-avx - add more optimized XTS code

    Add more optimized XTS code for camellia-aesni-avx, for smaller stack usage
    and small boost for speed.

    tcrypt results, with Intel i5-2450M:
            enc     dec
    16B     1.10x   1.01x
    64B     0.82x   0.77x
    256B    1.14x   1.10x
    1024B   1.17x   1.16x
    8192B   1.10x   1.11x

--
    Signed-off-by: Jussi Kivilinna <jussi.kivilinna-X3B1VOXEql0@public.gmane.org>
    Signed-off-by: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>


On Mon, May 6, 2013 at 9:00 AM, Shirish S Pargaonkar
<shirishp-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org> wrote:
>
> Steve, I am using Herbert Xu 3.8 git repository which has the code.
>
> Regards,
>
> Shirish
>
> Steve French ---05/05/2013 10:43:10 PM---Sounds great.  Has the new aes cmac lib been added to kernel yet in 3.10? On May 5, 2013 10:33 PM, "
>
>
>
>
>
>
>
>
>
>
>



--
Thanks,

Steve
