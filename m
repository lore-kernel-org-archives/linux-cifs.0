From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [RFC 01/10] crypto: factor async completion for general use
Date: Thu, 11 May 2017 10:29:47 +0300
Message-ID: <CAOtvUMezWBrHtGxJCBJHVks-XJdSCOMrRj3evsNdY=cB==wc-g@mail.gmail.com>
References: <1494075602-5061-1-git-send-email-gilad@benyossef.com>
 <1494075602-5061-2-git-send-email-gilad@benyossef.com> <20170511035527.GA2936@zzz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        David Howells <dhowells@redhat.com>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Shaohua Li <shli@kernel.org>, Steve French <sfrench@samba.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Ofir Drang <ofir.drang@arm.com>,
        Gilad Ben-Yossef <gilad.benyossef@arm.com>,
        linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        keyrings@vger.kernel.org,
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20170511035527.GA2936@zzz>
Sender: owner-linux-security-module@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Hi Eric,

On Thu, May 11, 2017 at 6:55 AM, Eric Biggers <ebiggers3@gmail.com> wrote:
> Hi Gilad,
>
> On Sat, May 06, 2017 at 03:59:50PM +0300, Gilad Ben-Yossef wrote:
>> Invoking a possibly async. crypto op and waiting for completion
>> while correctly handling backlog processing is a common task
>> in the crypto API implementation and outside users of it.
>>
>> This patch re-factors one of the in crypto API implementation in
>> preparation for using it across the board instead of hand
>> rolled versions.
>
> Thanks for doing this!  It annoyed me too that there wasn't a helper function
> for this.  Just a few comments below:
>

Thank you for the review.
I will incorporate the feedback into v2.

...

> With regards to the wait being uninterruptible, I agree that this should be the
> default behavior, because I think users waiting for specific crypto requests are
> generally not prepared to handle the wait actually being interrupted.  After
> interruption the crypto operation will still proceed in the background, and it
> will use buffers which the caller has in many cases already freed.  However, I'd
> suggest taking a close look at anything that was actually doing an interruptible
> wait before, to see whether it was a bug or intentional (or "doesn't matter").
>
> And yes there could always be a crypto_wait_req_interruptible() introduced if
> some users need it.

So this one was a bit of a shocker.  I though the  _interruptible use
sites seemed
wrong in the sense of being needless. However, after reading your feedback and
reviewing the code I'm pretty sure every single one of them (including
the one I've
added in dm-verity-target.c this merge window)  are down right dangerous and
can cause random data corruption... so thanks for pointing this out!

I though of this patch set as a "make the code pretty" for 4.13 kind
of patch set.
Looks like it's a bug fix now, maybe even stable material.

Anyway, I'll roll a v2 and we'll see.

Thanks,
Gilad

-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
