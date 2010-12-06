From: simo <idra@samba.org>
Subject: Re: [cifs-protocol] cifs client timeouts and hard/soft mounts
Date: Mon, 06 Dec 2010 11:49:15 -0500
Message-ID: <1291654155.3167.6.camel@pico.li.ssimo.org>
References: <20101203212811.17594274@tlielax.poochiereds.net>
	<E1POnFL-00BKfp-6h@intern.SerNet.DE>
	<AANLkTi=MCgZb=we2OEtxJ4DZ==sVmRLd8aQKeMU7vvKt@mail.gmail.com>
	<20101205210634.602b076b@corrin.poochiereds.net>
	<AANLkTik4Vh5hqWwVngjCC7v1ST1YxAP9LvQbcqKDhWHp@mail.gmail.com>
	<E1PPSnw-00DDbs-Va@intern.SerNet.DE>
	<AANLkTinPw8M6XaMvMQ_VMxdk7j8PDqdpjzKLgDMxPf1n@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs@vger.kernel.org, Volker.Lendecke@sernet.de,
	cifs-protocol@samba.org, samba-technical@lists.samba.org
To: Steve French <smfrench@gmail.com>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <AANLkTinPw8M6XaMvMQ_VMxdk7j8PDqdpjzKLgDMxPf1n@mail.gmail.com>
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

On Mon, 2010-12-06 at 10:28 -0600, Steve French wrote:
> On Sun, Dec 5, 2010 at 10:34 PM, Volker Lendecke
> <Volker.Lendecke@sernet.de> wrote:
> > Hi!
> >
> > On Sun, Dec 05, 2010 at 08:16:46PM -0600, Steve French wrote:
> >> I am more worried about firewall rule changes and similar events
> >> than about broken servers - but the idea of waiting forever on stat
> >> to a server that is never going to respond seems odd.
> >
> > That would be a strange fw rule that allows SMBEcho but not
> > other SMB requests. I think if someone puts up such a silly
> > rule, some pain is deserved :-)
> 
> Aaah - remember the proxies that cut out "chatty" smb traffic by
> responding on behalf of remote servers in the interest of optimizing
> traffic over slow links :)

They better send their own smb echos to remote servers then ...

Simo.

-- 
Simo Sorce
Samba Team GPL Compliance Officer <simo@samba.org>
Principal Software Engineer at Red Hat, Inc. <simo@redhat.com>
