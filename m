From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH RESEND] cifs: use memzero_explicit to clear stack buffer
Date: Mon, 12 Jan 2015 18:12:57 -0600
Message-ID: <CAH2r5muudE96Za2GHW0r=opq994UrWLoymvLri8fYz_Gcy0j7Q@mail.gmail.com>
References: <1420394744-20268-1-git-send-email-me@mortis.eu>
 <1420580220-6276-1-git-send-email-me@mortis.eu> <20150106225931.GA23281@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Giel van Schijndel <me@mortis.eu>,
	LKML <linux-kernel@vger.kernel.org>,
	Steve French <sfrench@samba.org>,
	"open list:COMMON INTERNET F..." <linux-cifs@vger.kernel.org>,
	"moderated list:COMMON INTERNET F..."
	<samba-technical@lists.samba.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150106225931.GA23281@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

merged into cifs-2.6.git for-next

On Tue, Jan 6, 2015 at 4:59 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Tue, Jan 06, 2015 at 10:37:00PM +0100, Giel van Schijndel wrote:
>> When leaving a function use memzero_explicit instead of memset(0) to
>> clear stack allocated buffers. memset(0) may be optimized away.
>>
>> This particular buffer is highly likely to contain sensitive data which
>> we shouldn't leak (it's named 'passwd' after all).
>>
>> Signed-off-by: Giel van Schijndel <me@mortis.eu>
>> Reported-at: http://www.viva64.com/en/b/0299/
>> Reported-by: Andrey Karpov
>> Reported-by: Svyatoslav Razmyslov
>
> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
>
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt



-- 
Thanks,

Steve
