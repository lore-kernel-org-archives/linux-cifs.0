From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH v7 00/19] simplify crypto wait for async op
Date: Sun, 3 Sep 2017 09:09:55 +0300
Message-ID: <CAOtvUMcyPQC1o5fof_RrbkEkeKaq5GB0u8qj4m+R+oG+btpv1A@mail.gmail.com>
References: <1503584350-7831-1-git-send-email-gilad@benyossef.com>
	<CAFXBA=n6W_n1P=NKHEUAgpaDDrdmh4QwB4aYma9xyio7UFP3Vw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4661010926525863906=="
Cc: Mike Snitzer <snitzer@redhat.com>, linux-doc@vger.kernel.org,
	Gary Hook <gary.hook@amd.com>, David Howells <dhowells@redhat.com>,
	device-mapper development <dm-devel@redhat.com>,
	keyrings@vger.kernel.org, linux-ima-devel@lists.sourceforge.net,
	Alasdair Kergon <agk@redhat.com>,
	Boris Brezillon <boris.brezillon@free-electrons.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, Jonathan Corbet <corbet@lwn.net>,
	Mimi Zohar <zohar@linux.vnet.ibm.com>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	linux-cifs@vger.kernel.org, linux-ima-user@lists.sourceforge.net,
	Arnaud Ebalard <arno@natisbad.org>, linux-raid@vger.kernel.org,
	linux-fscrypt@vger.kernel.org, linux-mediatek@lists.infradead.org,
	James Morris <james.l.morris@oracle.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>, linux-arm-kernel@lists.infradead.org,
	O
To: Harsh Jain <harshjain.prof@gmail.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAFXBA=n6W_n1P=NKHEUAgpaDDrdmh4QwB4aYma9xyio7UFP3Vw@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
List-Id: linux-cifs.vger.kernel.org

--===============4661010926525863906==
Content-Type: multipart/alternative; boundary="001a113d31ced2d7d8055842d7df"

--001a113d31ced2d7d8055842d7df
Content-Type: text/plain; charset="UTF-8"

On Thu, Aug 31, 2017 at 3:31 PM, Harsh Jain <harshjain.prof@gmail.com>
wrote:

> HI Gilad,
>
> I think we need an update in ESP also. Now EBUSY return means driver
> has accepted, Packet should not be dropped in
>
> esp_output_tail() function.
>
>
>
Good catch. You are right and the same holds true for ah_output() in ah4.c.

But I do wonder, the code there now treats -EBUSY as a special case and
returns NET_XMIT_DROP
but if an AEAD or AHASH transformation return some other error, like
-ENOMEM or -EINVAL shouldn't
we return NET_XMIT_DROP in that case too?

Any ideas?

Gilad


>
>
> On Thu, Aug 24, 2017 at 7:48 PM, Gilad Ben-Yossef <gilad@benyossef.com>
> wrote:
> > Many users of kernel async. crypto services have a pattern of
> > starting an async. crypto op and than using a completion
> > to wait for it to end.
> >
> > This patch set simplifies this common use case in two ways:
> >
> > First, by separating the return codes of the case where a
> > request is queued to a backlog due to the provider being
> > busy (-EBUSY) from the case the request has failed due
> > to the provider being busy and backlogging is not enabled
> > (-EAGAIN).
> >
> > Next, this change is than built on to create a generic API
> > to wait for a async. crypto operation to complete.
> >
> > The end result is a smaller code base and an API that is
> > easier to use and more difficult to get wrong.
> >
> > The patch set was boot tested on x86_64 and arm64 which
> > at the very least tests the crypto users via testmgr and
> > tcrypt but I do note that I do not have access to some
> > of the HW whose drivers are modified nor do I claim I was
> > able to test all of the corner cases.
> >
> > The patch set is based upon linux-next release tagged
> > next-20170824.
> >
> > Changes from v6:
> > - Fix brown paper bag compile error on marvell/cesa
> >   code.
> >
> > Changes from v5:
> > - Remove redundant new line as spotted by Jonathan
> >   Cameron.
> > - Reworded dm-verity change commit message to better
> >   clarify potential issue averted by change as
> >   pointed out by Mikulas Patocka.
> >
> > Changes from v4:
> > - Rebase on top of latest algif changes from Stephan
> >   Mueller.
> > - Fix typo in ccp patch title.
> >
> > Changes from v3:
> > - Instead of changing the return code to indicate
> >   backlog queueing, change the return code to indicate
> >   transient busy state, as suggested by Herbert Xu.
> >
> > Changes from v2:
> > - Patch title changed from "introduce crypto wait for
> >   async op" to better reflect the current state.
> > - Rebase on top of latest linux-next.
> > - Add a new return code of -EIOCBQUEUED for backlog
> >   queueing, as suggested by Herbert Xu.
> > - Transform more users to the new API.
> > - Update the drbg change to account for new init as
> >   indicated by Stephan Muller.
> >
> > Changes from v1:
> > - Address review comments from Eric Biggers.
> > - Separated out bug fixes of existing code and rebase
> >   on top of that patch set.
> > - Rename 'ecr' to 'wait' in fscrypto code.
> > - Split patch introducing the new API from the change
> >   moving over the algif code which it originated from
> >   to the new API.
> > - Inline crypto_wait_req().
> > - Some code indentation fixes.
> >
> > Gilad Ben-Yossef (19):
> >   crypto: change transient busy return code to -EAGAIN
> >   crypto: ccp: use -EAGAIN for transient busy indication
> >   crypto: remove redundant backlog checks on EBUSY
> >   crypto: marvell/cesa: remove redundant backlog checks on EBUSY
> >   crypto: introduce crypto wait for async op
> >   crypto: move algif to generic async completion
> >   crypto: move pub key to generic async completion
> >   crypto: move drbg to generic async completion
> >   crypto: move gcm to generic async completion
> >   crypto: move testmgr to generic async completion
> >   fscrypt: move to generic async completion
> >   dm: move dm-verity to generic async completion
> >   cifs: move to generic async completion
> >   ima: move to generic async completion
> >   crypto: tcrypt: move to generic async completion
> >   crypto: talitos: move to generic async completion
> >   crypto: qce: move to generic async completion
> >   crypto: mediatek: move to generic async completion
> >   crypto: adapt api sample to use async. op wait
> >
> >  Documentation/crypto/api-samples.rst |  52 ++-------
> >  crypto/af_alg.c                      |  27 -----
> >  crypto/ahash.c                       |  12 +--
> >  crypto/algapi.c                      |   6 +-
> >  crypto/algif_aead.c                  |   8 +-
> >  crypto/algif_hash.c                  |  50 +++++----
> >  crypto/algif_skcipher.c              |   9 +-
> >  crypto/api.c                         |  13 +++
> >  crypto/asymmetric_keys/public_key.c  |  28 +----
> >  crypto/cryptd.c                      |   4 +-
> >  crypto/cts.c                         |   6 +-
> >  crypto/drbg.c                        |  36 ++-----
> >  crypto/gcm.c                         |  32 ++----
> >  crypto/lrw.c                         |   8 +-
> >  crypto/rsa-pkcs1pad.c                |  16 +--
> >  crypto/tcrypt.c                      |  84 +++++----------
> >  crypto/testmgr.c                     | 204
> ++++++++++++-----------------------
> >  crypto/xts.c                         |   8 +-
> >  drivers/crypto/ccp/ccp-crypto-main.c |   8 +-
> >  drivers/crypto/ccp/ccp-dev.c         |   7 +-
> >  drivers/crypto/marvell/cesa.c        |   3 +-
> >  drivers/crypto/marvell/cesa.h        |   2 +-
> >  drivers/crypto/mediatek/mtk-aes.c    |  31 +-----
> >  drivers/crypto/qce/sha.c             |  30 +-----
> >  drivers/crypto/talitos.c             |  38 +------
> >  drivers/md/dm-verity-target.c        |  81 ++++----------
> >  drivers/md/dm-verity.h               |   5 -
> >  fs/cifs/smb2ops.c                    |  30 +-----
> >  fs/crypto/crypto.c                   |  28 +----
> >  fs/crypto/fname.c                    |  36 ++-----
> >  fs/crypto/fscrypt_private.h          |  10 --
> >  fs/crypto/keyinfo.c                  |  21 +---
> >  include/crypto/drbg.h                |   3 +-
> >  include/crypto/if_alg.h              |  15 +--
> >  include/linux/crypto.h               |  40 +++++++
> >  security/integrity/ima/ima_crypto.c  |  56 +++-------
> >  36 files changed, 310 insertions(+), 737 deletions(-)
> >
> > --
> > 2.1.4
> >
>



-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a situation
where the homework eats your dog?"
 -- Jean-Baptiste Queru

--001a113d31ced2d7d8055842d7df
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><div class=3D"gmail_extra"><br><div class=3D"gmail_quo=
te">On Thu, Aug 31, 2017 at 3:31 PM, Harsh Jain <span dir=3D"ltr">&lt;<a hr=
ef=3D"mailto:harshjain.prof@gmail.com" target=3D"_blank">harshjain.prof@gma=
il.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"=
margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-lef=
t:1ex">HI Gilad,<br>
<br>
I think we need an update in ESP also. Now EBUSY return means driver<br>
has accepted, Packet should not be dropped in<br>
<br>
esp_output_tail() function.<br>
<br><br></blockquote><div><br></div><div>Good catch. You are right and the =
same holds true for ah_output() in ah4.c.</div><div><br></div><div>But I do=
 wonder, the code there now treats -EBUSY as a special case and returns=C2=
=A0NET_XMIT_DROP</div><div>but if an AEAD or AHASH transformation return so=
me other error, like -ENOMEM or -EINVAL shouldn&#39;t</div><div>we return N=
ET_XMIT_DROP in that case too?=C2=A0</div><div><br></div><div>Any ideas?</d=
iv><div><br></div><div>Gilad</div><div><br></div><blockquote class=3D"gmail=
_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204=
,204);padding-left:1ex"><div class=3D"gmail-HOEnZb"><div class=3D"gmail-h5"=
><br>
<br>
<br>
On Thu, Aug 24, 2017 at 7:48 PM, Gilad Ben-Yossef &lt;<a href=3D"mailto:gil=
ad@benyossef.com">gilad@benyossef.com</a>&gt; wrote:<br>
&gt; Many users of kernel async. crypto services have a pattern of<br>
&gt; starting an async. crypto op and than using a completion<br>
&gt; to wait for it to end.<br>
&gt;<br>
&gt; This patch set simplifies this common use case in two ways:<br>
&gt;<br>
&gt; First, by separating the return codes of the case where a<br>
&gt; request is queued to a backlog due to the provider being<br>
&gt; busy (-EBUSY) from the case the request has failed due<br>
&gt; to the provider being busy and backlogging is not enabled<br>
&gt; (-EAGAIN).<br>
&gt;<br>
&gt; Next, this change is than built on to create a generic API<br>
&gt; to wait for a async. crypto operation to complete.<br>
&gt;<br>
&gt; The end result is a smaller code base and an API that is<br>
&gt; easier to use and more difficult to get wrong.<br>
&gt;<br>
&gt; The patch set was boot tested on x86_64 and arm64 which<br>
&gt; at the very least tests the crypto users via testmgr and<br>
&gt; tcrypt but I do note that I do not have access to some<br>
&gt; of the HW whose drivers are modified nor do I claim I was<br>
&gt; able to test all of the corner cases.<br>
&gt;<br>
&gt; The patch set is based upon linux-next release tagged<br>
&gt; next-20170824.<br>
&gt;<br>
&gt; Changes from v6:<br>
&gt; - Fix brown paper bag compile error on marvell/cesa<br>
&gt;=C2=A0 =C2=A0code.<br>
&gt;<br>
&gt; Changes from v5:<br>
&gt; - Remove redundant new line as spotted by Jonathan<br>
&gt;=C2=A0 =C2=A0Cameron.<br>
&gt; - Reworded dm-verity change commit message to better<br>
&gt;=C2=A0 =C2=A0clarify potential issue averted by change as<br>
&gt;=C2=A0 =C2=A0pointed out by Mikulas Patocka.<br>
&gt;<br>
&gt; Changes from v4:<br>
&gt; - Rebase on top of latest algif changes from Stephan<br>
&gt;=C2=A0 =C2=A0Mueller.<br>
&gt; - Fix typo in ccp patch title.<br>
&gt;<br>
&gt; Changes from v3:<br>
&gt; - Instead of changing the return code to indicate<br>
&gt;=C2=A0 =C2=A0backlog queueing, change the return code to indicate<br>
&gt;=C2=A0 =C2=A0transient busy state, as suggested by Herbert Xu.<br>
&gt;<br>
&gt; Changes from v2:<br>
&gt; - Patch title changed from &quot;introduce crypto wait for<br>
&gt;=C2=A0 =C2=A0async op&quot; to better reflect the current state.<br>
&gt; - Rebase on top of latest linux-next.<br>
&gt; - Add a new return code of -EIOCBQUEUED for backlog<br>
&gt;=C2=A0 =C2=A0queueing, as suggested by Herbert Xu.<br>
&gt; - Transform more users to the new API.<br>
&gt; - Update the drbg change to account for new init as<br>
&gt;=C2=A0 =C2=A0indicated by Stephan Muller.<br>
&gt;<br>
&gt; Changes from v1:<br>
&gt; - Address review comments from Eric Biggers.<br>
&gt; - Separated out bug fixes of existing code and rebase<br>
&gt;=C2=A0 =C2=A0on top of that patch set.<br>
&gt; - Rename &#39;ecr&#39; to &#39;wait&#39; in fscrypto code.<br>
&gt; - Split patch introducing the new API from the change<br>
&gt;=C2=A0 =C2=A0moving over the algif code which it originated from<br>
&gt;=C2=A0 =C2=A0to the new API.<br>
&gt; - Inline crypto_wait_req().<br>
&gt; - Some code indentation fixes.<br>
&gt;<br>
&gt; Gilad Ben-Yossef (19):<br>
&gt;=C2=A0 =C2=A0crypto: change transient busy return code to -EAGAIN<br>
&gt;=C2=A0 =C2=A0crypto: ccp: use -EAGAIN for transient busy indication<br>
&gt;=C2=A0 =C2=A0crypto: remove redundant backlog checks on EBUSY<br>
&gt;=C2=A0 =C2=A0crypto: marvell/cesa: remove redundant backlog checks on E=
BUSY<br>
&gt;=C2=A0 =C2=A0crypto: introduce crypto wait for async op<br>
&gt;=C2=A0 =C2=A0crypto: move algif to generic async completion<br>
&gt;=C2=A0 =C2=A0crypto: move pub key to generic async completion<br>
&gt;=C2=A0 =C2=A0crypto: move drbg to generic async completion<br>
&gt;=C2=A0 =C2=A0crypto: move gcm to generic async completion<br>
&gt;=C2=A0 =C2=A0crypto: move testmgr to generic async completion<br>
&gt;=C2=A0 =C2=A0fscrypt: move to generic async completion<br>
&gt;=C2=A0 =C2=A0dm: move dm-verity to generic async completion<br>
&gt;=C2=A0 =C2=A0cifs: move to generic async completion<br>
&gt;=C2=A0 =C2=A0ima: move to generic async completion<br>
&gt;=C2=A0 =C2=A0crypto: tcrypt: move to generic async completion<br>
&gt;=C2=A0 =C2=A0crypto: talitos: move to generic async completion<br>
&gt;=C2=A0 =C2=A0crypto: qce: move to generic async completion<br>
&gt;=C2=A0 =C2=A0crypto: mediatek: move to generic async completion<br>
&gt;=C2=A0 =C2=A0crypto: adapt api sample to use async. op wait<br>
&gt;<br>
&gt;=C2=A0 Documentation/crypto/api-<wbr>samples.rst |=C2=A0 52 ++-------<b=
r>
&gt;=C2=A0 crypto/af_alg.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 27 -----<br>
&gt;=C2=A0 crypto/ahash.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 12 +--<br>
&gt;=C2=A0 crypto/algapi.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A06 +-<br>
&gt;=C2=A0 crypto/algif_aead.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A08 +-<br>
&gt;=C2=A0 crypto/algif_hash.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 |=C2=A0 50 +++++----<br>
&gt;=C2=A0 crypto/algif_skcipher.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 |=C2=A0 =C2=A09 +-<br>
&gt;=C2=A0 crypto/api.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 13 +++<br>
&gt;=C2=A0 crypto/asymmetric_keys/public_<wbr>key.c=C2=A0 |=C2=A0 28 +----<=
br>
&gt;=C2=A0 crypto/cryptd.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A04 +-<br>
&gt;=C2=A0 crypto/cts.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A06 +-<br>
&gt;=C2=A0 crypto/drbg.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 36 ++-----<br>
&gt;=C2=A0 crypto/gcm.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 32 ++----<br>
&gt;=C2=A0 crypto/lrw.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A08 +-<br>
&gt;=C2=A0 crypto/rsa-pkcs1pad.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 |=C2=A0 16 +--<br>
&gt;=C2=A0 crypto/tcrypt.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 84 +++++----------<br>
&gt;=C2=A0 crypto/testmgr.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0| 204 ++++++++++++------------------<wbr>-----<=
br>
&gt;=C2=A0 crypto/xts.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A08 +-<br>
&gt;=C2=A0 drivers/crypto/ccp/ccp-crypto-<wbr>main.c |=C2=A0 =C2=A08 +-<br>
&gt;=C2=A0 drivers/crypto/ccp/ccp-dev.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=
=C2=A0 =C2=A07 +-<br>
&gt;=C2=A0 drivers/crypto/marvell/cesa.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0=
 =C2=A03 +-<br>
&gt;=C2=A0 drivers/crypto/marvell/cesa.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0=
 =C2=A02 +-<br>
&gt;=C2=A0 drivers/crypto/mediatek/mtk-<wbr>aes.c=C2=A0 =C2=A0 |=C2=A0 31 +=
-----<br>
&gt;=C2=A0 drivers/crypto/qce/sha.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0|=C2=A0 30 +-----<br>
&gt;=C2=A0 drivers/crypto/talitos.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0|=C2=A0 38 +------<br>
&gt;=C2=A0 drivers/md/dm-verity-target.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0=
 81 ++++----------<br>
&gt;=C2=A0 drivers/md/dm-verity.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0|=C2=A0 =C2=A05 -<br>
&gt;=C2=A0 fs/cifs/smb2ops.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 30 +-----<br>
&gt;=C2=A0 fs/crypto/crypto.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 28 +----<br>
&gt;=C2=A0 fs/crypto/fname.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 36 ++-----<br>
&gt;=C2=A0 fs/crypto/fscrypt_private.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=
=C2=A0 10 --<br>
&gt;=C2=A0 fs/crypto/keyinfo.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 |=C2=A0 21 +---<br>
&gt;=C2=A0 include/crypto/drbg.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 |=C2=A0 =C2=A03 +-<br>
&gt;=C2=A0 include/crypto/if_alg.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 |=C2=A0 15 +--<br>
&gt;=C2=A0 include/linux/crypto.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0|=C2=A0 40 +++++++<br>
&gt;=C2=A0 security/integrity/ima/ima_<wbr>crypto.c=C2=A0 |=C2=A0 56 +++---=
----<br>
&gt;=C2=A0 36 files changed, 310 insertions(+), 737 deletions(-)<br>
&gt;<br>
&gt; --<br>
&gt; 2.1.4<br>
&gt;<br>
</div></div></blockquote></div><br><br clear=3D"all"><div><br></div>-- <br>=
<div class=3D"gmail_signature">Gilad Ben-Yossef<br>Chief Coffee Drinker<br>=
<br>&quot;If you take a class in large-scale robotics, can you end up in a =
situation where the homework eats your dog?&quot;<br>=C2=A0-- Jean-Baptiste=
 Queru</div>
</div></div>

--001a113d31ced2d7d8055842d7df--


--===============4661010926525863906==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4661010926525863906==--
