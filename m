From: Gilad Ben-Yossef <gilad-6S/DczAoZh3WXxRugSxzZg@public.gmane.org>
Subject: Re: [PATCH v3 01/28] crypto: change backlog return code to -EIOCBQUEUED
Date: Mon, 3 Jul 2017 16:23:18 +0300
Message-ID: <CAOtvUMdoMfrpZPuRfD_cQo4=FDp5Vn4uv51Vzc-0Gitmvr2V6g@mail.gmail.com>
References: <1499006535-19760-1-git-send-email-gilad@benyossef.com>
 <1499006535-19760-2-git-send-email-gilad@benyossef.com> <20170703123515.GC30067@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
        Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>,
        David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>,
        Gary Hook <gary.hook-5C7GfCeVMHo@public.gmane.org>,
        Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>,
        Arnaud Ebalard <arno-LkuqDEemtHBg9hUCZPvPmw@public.gmane.org>,
        Matthias Brugger <matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        "Theodore Y. Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>,
        Jaegeuk Kim <jaegeuk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>,
        Dmitry Kasatkin <dmitry.kasatkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>,
        "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170703123515.GC30067-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Jul 3, 2017 at 3:35 PM, Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org> wrote:
> On Sun, Jul 02, 2017 at 05:41:43PM +0300, Gilad Ben-Yossef wrote:
>> The crypto API was using the -EBUSY return value to indicate
>> both a hard failure to submit a crypto operation into a
>> transformation provider when the latter was busy and the backlog
>> mechanism was not enabled as well as a notification that the operation
>> was queued into the backlog when the backlog mechanism was enabled.
>>
>> Having the same return code indicate two very different conditions
>> depending on a flag is both error prone and requires extra runtime
>> check like the following to discern between the cases:
>>
>>       if (err == -EINPROGRESS ||
>>           (err == -EBUSY && (ahash_request_flags(req) &
>>                              CRYPTO_TFM_REQ_MAY_BACKLOG)))
>>
>> This patch changes the return code used to indicate a crypto op
>> was queued in the backlog to -EIOCBQUEUED, thus resolving both
>> issues.
>>
>> Signed-off-by: Gilad Ben-Yossef <gilad-6S/DczAoZh3WXxRugSxzZg@public.gmane.org>
>
> So you're changing the success case from EBUSY to EIOCBQUEUED.
> This results in a lot of churn as you have to change every single
> driver and caller.
>
> How about changing the error case to use something other than
> EBUSY instead?

That was indeed my first thought - I wanted to change EBUSY to EAGAIN.
It might even be a more descriptive error message since the failure is
transient.

What stopped me was that I saw the algif interface passes this EBUSY value
to user space. I don't know of any software that depends on this value but
I'm really averse to changing user space API.

Of course, we can just plant a (ret != AGAIN : ? EBUSY) in the algif interface
return to user space code path but that felt like a kludge to me.

And it doesn't really save any churn, I think - I'd still have to
visit all the places that
use the flags value to distinguish between the two EBUSY use cases and  I need
to visit most places that check for EBUSY as backlog indication because I'm
replacing the check with the generic replacement, so it doesn't look
like in the end
it will be a smaller change.

Having said that, if you prefer me to replace the error case I'd
happily do that.

Thanks,
Gilad


-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
