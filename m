From: Shirish S Pargaonkar <shirishp@us.ibm.com>
Subject: Re: AES Crypto Support in Kernel
Date: Mon, 6 May 2013 11:56:35 -0500
Message-ID: <OFCE41C518.EEB2870F-ON87257B63.005CDE72-86257B63.005D13BF@us.ibm.com>
References: <CAH2r5muCod5S7PgRgD6CEbSwFtXykUmyP8fusRqLt-KLW1cMvQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: linux-cifs@vger.kernel.org,
	samba-technical <samba-technical@lists.samba.org>,
	Jeff Layton <jlayton@redhat.com>
To: Steve French <smfrench@gmail.com>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <CAH2r5muCod5S7PgRgD6CEbSwFtXykUmyP8fusRqLt-KLW1cMvQ@mail.gmail.com>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org



Steve French <smfrench@gmail.com> wrote on 05/06/2013 09:11:28 AM:

> From:
>
> Steve French <smfrench@gmail.com>
>
> To:
>
> Shirish S Pargaonkar/Austin/IBM@IBMUS
>
> Cc:
>
> Jeff Layton <jlayton@redhat.com>, Pavel Shilovsky
> <piastryyy@gmail.com>, linux-cifs@vger.kernel.org, samba-technical
> <samba-technical@lists.samba.org>
>
> Date:
>
> 05/06/2013 09:13 AM
>
> Subject:
>
> AES Crypto Support in Kernel
>
> Shirish,
> Does the recent crypto merge to kernel, which includes these two
> patches for example, help you (at least on the more common chips,
> those with optimized AES offload support)?  Wonder if we can leverage
> the hardware offload in Samba?
>
> commit c456a9cd1ac4eae9147ffd7ac4fb77ca0fa980c6
> Author: Jussi Kivilinna <jussi.kivilinna@iki.fi>
> Date:   Mon Apr 8 21:51:16 2013 +0300
>
>     crypto: aesni_intel - add more optimized XTS mode for x86-64
>
>     Add more optimized XTS code for aesni_intel in 64-bit mode, for
> smaller stack
>     usage and boost for speed.
>
>     tcrypt results, with Intel i5-2450M:
>     256-bit key
>             enc     dec
>     16B     0.98x   0.99x
>     64B     0.64x   0.63x
>     256B    1.29x   1.32x
>     1024B   1.54x   1.58x
>     8192B   1.57x   1.60x
> --
>     performance is reduced in tcrypt for 64 byte long blocks.
>
>     Cc: Huang Ying <ying.huang@intel.com>
>     Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
>     Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>
> commit b5c5b072dc2f35d45d3404b957e264a3e8e71069
> Author: Jussi Kivilinna <jussi.kivilinna@iki.fi>
> Date:   Mon Apr 8 21:51:11 2013 +0300
>
>     crypto: x86/camellia-aesni-avx - add more optimized XTS code
>
>     Add more optimized XTS code for camellia-aesni-avx, for smaller
> stack usage
>     and small boost for speed.
>
>     tcrypt results, with Intel i5-2450M:
>             enc     dec
>     16B     1.10x   1.01x
>     64B     0.82x   0.77x
>     256B    1.14x   1.10x
>     1024B   1.17x   1.16x
>     8192B   1.10x   1.11x
>
> --
>     Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
>     Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>
>
> On Mon, May 6, 2013 at 9:00 AM, Shirish S Pargaonkar
> <shirishp@us.ibm.com> wrote:
> >
> > Steve, I am using Herbert Xu 3.8 git repository which has the code.
> >
> > Regards,
> >
> > Shirish
> >
> > Steve French ---05/05/2013 10:43:10 PM---Sounds great.  Has the
> new aes cmac lib been added to kernel yet in 3.10? On May 5, 2013 10:33
PM, "
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
> >
>
>
>
> --
> Thanks,
>
> Steve
>

Steve, Jeff,

I am not sure how all this comes together.

Currently cifs client uses kernel crypto code during authentication
and signing (signature generation), mostly for NTLMSSP.

So I am not sure how and where Samba comes into picture.
Would we want to change from using kernel cryto code to either code
within Samba (which APIs?) or the code that Samba uses (NSS libs (APIs?))
and if so, would that mean making kernel upcalls?

And then what kind of hardware do we need to measure the performance
(improvment) and how do we measure the performacne (improvment).

Not sure what all Samba crypto code has or the NSS libs have but I
would think it has all the hash generating functions that cifs client
needs include CMAC-AES!

Regards,

Shirish
