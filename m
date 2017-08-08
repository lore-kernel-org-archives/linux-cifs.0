From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v4 06/19] crypto: move algif to generic async
	completion
Date: Tue, 08 Aug 2017 15:10:01 +0200
Message-ID: <8585274.Umn6qnzcUd@tauon.chronox.de>
References: <1502193834-11289-1-git-send-email-gilad@benyossef.com>
	<1502193834-11289-7-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Mike Snitzer <snitzer@redhat.com>, linux-doc@vger.kernel.org,
	Gary Hook <gary.hook@amd.com>, David Howells <dhowells@redhat.com>,
	samba.-technical@lists.samba.org, dm-devel@redhat.com,
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
	Jaegeuk Kim <jaegeuk@kernel.org>, linux-arm-kernel@lists.infradead.o
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1502193834-11289-7-git-send-email-gilad@benyossef.com>
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

Am Dienstag, 8. August 2017, 14:03:37 CEST schrieb Gilad Ben-Yossef:

Hi Gilad,

> algif starts several async crypto ops and waits for their completion.
> Move it over to generic code doing the same.

Just FYI: your patch set and my patch [1] will clash.

[1] https://patchwork.kernel.org/patch/9875959/

Ciao
Stephan
