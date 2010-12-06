From: Steve French <smfrench@gmail.com>
Subject: Re: cifs client timeouts and hard/soft mounts
Date: Sun, 5 Dec 2010 19:42:30 -0600
Message-ID: <AANLkTi=MCgZb=we2OEtxJ4DZ==sVmRLd8aQKeMU7vvKt@mail.gmail.com>
References: <20101203212811.17594274@tlielax.poochiereds.net>
	<E1POnFL-00BKfp-6h@intern.SerNet.DE>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs@vger.kernel.org, cifs-protocol@samba.org,
	samba-technical@lists.samba.org
To: Volker.Lendecke@sernet.de
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <E1POnFL-00BKfp-6h@intern.SerNet.DE>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

On Sat, Dec 4, 2010 at 2:12 AM, Volker Lendecke
<Volker.Lendecke@sernet.de>wrote:

> On Fri, Dec 03, 2010 at 09:28:11PM -0500, Jeff Layton wrote:
> > So, what does this mean for CIFS clients? I believe that the best
> > behavior for the client is to *never* time out an individual request,
> > aside from SMB echoes.
>
> I like this concept.
>
>
That will break apps that can't take ctl-c though ...

-- 
Thanks,

Steve
