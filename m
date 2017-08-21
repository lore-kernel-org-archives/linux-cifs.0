From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH v5 05/19] crypto: introduce crypto wait for async op
Date: Mon, 21 Aug 2017 15:49:41 +0300
Message-ID: <CAOtvUMfJaG-Uomc1EnD1+HySz+X8SUaRUm1SEx4DusquWfOF0w@mail.gmail.com>
References: <1502724094-23305-1-git-send-email-gilad@benyossef.com>
 <1502724094-23305-6-git-send-email-gilad@benyossef.com> <20170815032303.000042b2@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        David Howells <dhowells@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Arnaud Ebalard <arno@natisbad.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        device-mapper development <dm-devel@redhat.com>,
        Shaohua Li <shli@kernel.org>, Steve French <sfrench@samba.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20170815032303.000042b2@huawei.com>
Sender: owner-linux-security-module@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Tue, Aug 15, 2017 at 5:23 AM, Jonathan Cameron
<Jonathan.Cameron@huawei.com> wrote:
> On Mon, 14 Aug 2017 18:21:15 +0300
> Gilad Ben-Yossef <gilad@benyossef.com> wrote:
>
>> Invoking a possibly async. crypto op and waiting for completion
>> while correctly handling backlog processing is a common task
>> in the crypto API implementation and outside users of it.
>>
>> This patch adds a generic implementation for doing so in
>> preparation for using it across the board instead of hand
>> rolled versions.

>
> Trivial observation.  Shouldn't have this bonus blank line inserted here.
>
>>  #endif       /* _LINUX_CRYPTO_H */
>>
>

Indeed. Will be fixed.

Thanks,
Gilad

-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
