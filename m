From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH v6 04/19] crypto: marvell/cesa: remove
 redundant backlog checks on EBUSY
Date: Thu, 24 Aug 2017 16:25:14 +0300
Message-ID: <CAOtvUMcJXyupc1N+wRRfJNWwS2P9V36J0_eYHLbdDtj4kWaYxw@mail.gmail.com>
References: <1503324309-13673-5-git-send-email-gilad@benyossef.com>
	<201708242036.ODpqdw7q%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Mike Snitzer <snitzer@redhat.com>, linux-doc@vger.kernel.org,
	Gary Hook <gary.hook@amd.com>, David Howells <dhowells@redhat.com>,
	device-mapper development <dm-devel@redhat.com>,
	keyrings@vger.kernel.org, linux-ima-devel@lists.sourceforge.net,
	Alasdair Kergon <agk@redhat.com>,
	Boris Brezillon <boris.brezillon@free-electrons.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, Jonathan Corbet <corbet@lwn.net>,
	Mimi Zohar <zohar@linux.vnet.ibm.com>, kbuild-all@01.org,
	Tom Lendacky <thomas.lendacky@amd.com>,
	linux-cifs@vger.kernel.org, linux-ima-user@lists.sourceforge.net,
	Arnaud Ebalard <arno@natisbad.org>, linux-raid@vger.kernel.org,
	linux-fscrypt@vger.kernel.org, linux-mediatek@lists.infradead.org,
	James Morris <james.l.morris@oracle.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>, linux-arm-kernel@lists.infradead.org,
	Ofir Drang <ofir.dran
To: kbuild test robot <lkp@intel.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <201708242036.ODpqdw7q%fengguang.wu@intel.com>
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

On Thu, Aug 24, 2017 at 4:01 PM, kbuild test robot <lkp@intel.com> wrote:
> Hi Gilad,
>
> [auto build test ERROR on cryptodev/master]
> [also build test ERROR on v4.13-rc6 next-20170823]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
>
> url:    https://github.com/0day-ci/linux/commits/Gilad-Ben-Yossef/crypto-change-transient-busy-return-code-to-EAGAIN/20170824-180606
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> config: arm-allmodconfig (attached as .config)
> compiler: arm-linux-gnueabi-gcc (Debian 6.1.1-9) 6.1.1 20160705
> reproduce:
>         wget https://raw.githubusercontent.com/01org/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         make.cross ARCH=arm
>
> All error/warnings (new ones prefixed by >>):
>
>    drivers/crypto/marvell/cesa.c: In function 'mv_cesa_queue_req':
>>> drivers/crypto/marvell/cesa.c:187:3: error: expected ')' before 'mv_cesa_tdma_chain'
>       mv_cesa_tdma_chain(engine, creq);
>       ^~~~~~~~~~~~~~~~~~
>>> drivers/crypto/marvell/cesa.c:196:1: error: expected expression before '}' token
>     }
>     ^
>>> drivers/crypto/marvell/cesa.c:196:1: warning: control reaches end of non-void function [-Wreturn-type]
>     }
>     ^

Oy! I thought I've added COMPILE_TEST to my local tree to build it. I didn't.

Fix underway.

Gilad

-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
