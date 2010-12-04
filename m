From: Volker Lendecke <Volker.Lendecke@SerNet.DE>
Subject: Re: cifs client timeouts and hard/soft mounts
Date: Sat, 4 Dec 2010 09:12:04 +0100
Message-ID: <E1POnFL-00BKfp-6h@intern.SerNet.DE>
References: <20101203212811.17594274@tlielax.poochiereds.net>
Reply-To: Volker.Lendecke@SerNet.DE
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs@vger.kernel.org, cifs-protocol@samba.org,
	samba-technical@lists.samba.org
To: Jeff Layton <jlayton@samba.org>
Return-path: <samba-technical-bounces@lists.samba.org>
Date: Sat, 4 Dec 2010 09:12:04 +0100
Content-Disposition: inline
In-Reply-To: <20101203212811.17594274@tlielax.poochiereds.net>
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

On Fri, Dec 03, 2010 at 09:28:11PM -0500, Jeff Layton wrote:
> So, what does this mean for CIFS clients? I believe that the best
> behavior for the client is to *never* time out an individual request,
> aside from SMB echoes.

I like this concept.

Volker
