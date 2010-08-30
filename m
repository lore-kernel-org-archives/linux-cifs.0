From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: Linux 2.6.36-rc3
Date: Mon, 30 Aug 2010 10:25:27 -0700
Message-ID: <20100830102527.17d5e1f1.randy.dunlap@oracle.com>
References: <AANLkTinRRiW1VUzS+3T82=q8PsoRn78Cgn_X8gSduM0U@mail.gmail.com>
	<i5fr6h$ih6$1@dough.gmane.org>
	<4C7BE3AE.8020204@suse.de>
	<AANLkTi=S3E80edLwAAAOwehrakYVgeKzC+yKptwJJZLc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Suresh Jayaraman <sjayaraman@suse.de>,
	Miguel Calleja <mcalleja1@telecable.es>,
	LKML <linux-kernel@vger.kernel.org>, linux-cifs@vger.kernel.org,
	Shirish S Pargaonkar <shirishp@us.ibm.com>
To: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=S3E80edLwAAAOwehrakYVgeKzC+yKptwJJZLc@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Mon, 30 Aug 2010 12:14:53 -0500 Shirish Pargaonkar wrote:

> On Mon, Aug 30, 2010 at 12:00 PM, Suresh Jayaraman <sjayaraman@suse.de> wrote:
> > (Cc linux-cifs@vger.kernel.org)
> >
> > Couldn't get a chance to check this, but I guess this is perhaps due to
> > the recent crypto patches..
> 
> Suresh, yes, cifs auth and signing code using kernel crypto (shash) apis.
> 
> fs/cifs/Kconfig
> 
>         select CRYPTO_MD5
>         select CRYPTO_ARC4
> 

Either CIFS should depend on CRYPTO:
change
	depends on INET
to
	depends on INET && CRYPTO

or it can also select CRYPTO.

> 
> >
> > On 08/30/2010 02:17 PM, Miguel Calleja wrote:
> >> CIFS does not build without CRYPTO selected.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
