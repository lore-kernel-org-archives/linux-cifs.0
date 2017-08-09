From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH v4 02/19] crypto: ccm: use -EAGAIN for transient busy indication
Date: Wed, 9 Aug 2017 08:18:03 +0300
Message-ID: <CAOtvUMeUHk9KxQumhuvJ52dp-_-LFOD8XGvCWvhU6LjEZhEF7A@mail.gmail.com>
References: <1502193834-11289-1-git-send-email-gilad@benyossef.com>
 <1502193834-11289-3-git-send-email-gilad@benyossef.com> <4600c898-a2f2-f95f-15b4-0adcc6acc0b5@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        David Howells <dhowells@redhat.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Arnaud Ebalard <arno@natisbad.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        Shaohua Li <shli@kernel.org>, Steve French <sfrench@samba.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        "linux-
To: Gary R Hook <gary.hook@amd.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <4600c898-a2f2-f95f-15b4-0adcc6acc0b5@amd.com>
Sender: owner-linux-security-module@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Tue, Aug 8, 2017 at 6:24 PM, Gary R Hook <gary.hook@amd.com> wrote:
> On 08/08/2017 07:03 AM, Gilad Ben-Yossef wrote:
>>
>> Replace -EBUSY with -EAGAIN when reporting transient busy
>> indication in the absence of backlog.
>>
>> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
>
>
> Could we use "ccp" in the subject line, please?

Of course, sorry about the the typo.

Gilad

-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
