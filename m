From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH v2 04/11] crypto: move drbg to generic async
	completion
Date: Mon, 29 May 2017 11:04:01 +0200
Message-ID: <1638335.mkZCLTBCSi@tauon.chronox.de>
References: <1496046180-21962-1-git-send-email-gilad@benyossef.com>
	<1496046180-21962-5-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: linux-security-module@l.org, Mike Snitzer <snitzer@redhat.com>,
	linux-doc@vger.kernel.org, David Howells <dhowells@redhat.com>,
	dm-devel@redhat.com, keyrings@vger.kernel.org,
	linux-ima-devel@lists.sourceforge.net,
	Pavel Shilovsky <pshilov@microsoft.com>,
	Alasdair Kergon <agk@redhat.com>, linux-cifs@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>, Jonathan Corbet <corbet@lwn.net>,
	Mimi Zohar <zohar@linux.vnet.ibm.com>,
	"Serge E. Hallyn" <serge@hallyn.com>, linux-ima-user@lists.sourceforge.net,
	Eric Biggers <ebiggers3@gmail.com>, linux-raid@vger.kernel.org,
	linux-fscrypt@vger.kernel.org, James Morris <james.l.morris@oracle.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>, Ofir Drang <ofir.drang@arm.com>,
	"Theodore Y. Ts'o" <tytso@mit.edu>,
	Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
	Steve French <sfrench@sam
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1496046180-21962-5-git-send-email-gilad@benyossef.com>
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

Am Montag, 29. Mai 2017, 10:22:51 CEST schrieb Gilad Ben-Yossef:

Hi Gilad,

> DRBG is starting an async. crypto op and waiting for it complete.
> Move it over to generic code doing the same.
> =

> The code now also passes CRYPTO_TFM_REQ_MAY_SLEEP flag indicating
> crypto request memory allocation may use GFP_KERNEL which should
> be perfectly fine as the code is obviously sleeping for the
> completion of the request any way.
> =

> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>

Acked-by: Stephan M=FCller <smueller@chronox.de>

However, please note that there is a patch "crypto:drbg- Fixes panic in =

wait_for_completion call." which adds another init_completion. I guess that =

needs conversion to crypto_init_wait as well, once this patch set is accept=
ed.


Ciao
Stephan
