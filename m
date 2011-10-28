From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [patch] cifs: accidentally creating empty files
Date: Fri, 28 Oct 2011 10:20:19 +0300
Message-ID: <20111028072019.GA14900@longonot.mountain>
References: <20110927212810.GA12900@elgon.mountain>
	<20111013132755.6c5db87e@barsoom.rdu.redhat.com>
	<CAH2r5mtOF=Ja7_mTK576uEqgZqaVH+8YXtOqmZVknBC81sD=8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steve French <sfrench@samba.org>, samba-technical@lists.samba.org,
	linux-cifs@vger.kernel.org
To: Steve French <smfrench@gmail.com>
Return-path: <samba-technical-bounces@lists.samba.org>
Content-Disposition: inline
In-Reply-To: <CAH2r5mtOF=Ja7_mTK576uEqgZqaVH+8YXtOqmZVknBC81sD=8Q@mail.gmail.com>
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

On Wed, Oct 19, 2011 at 09:14:37PM -0500, Steve French wrote:
> Doesn't this force the create to happen later - rather than
> at lookup time where it belongs?
> 
> if the issue is just noperm ... we should let this through if the user
> has local permissions.  Doubling the cost of a file create to Samba
> seems like a bad idea (ie doing aQueryPathInfo AND an NTCreateX
> doubles the roundrip, doubles the load on the server etc.) - the whole
> point of this is to let us do an "atomic" open or create operation
> and not have to split it into multiple requests.  In any case why would
> we do the open and then follow it with a create?
> 
> Can we fix this to (at least) narrow the performance penalty.
> 

Yes, it does add another back and forth to file create...  It's hard/
impossible to check the permissions first and then decide whether to
pass the O_CREAT flag.  Maybe we could add an if statement to check
whether noperm was used and the noperm version could use the create
on lookup.  It's obviously not pretty but it might be worth it for
speedup.

regards,
dan carpenter
