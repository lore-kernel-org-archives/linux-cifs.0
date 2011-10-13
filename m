From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [patch] cifs: accidentally creating empty files
Date: Thu, 13 Oct 2011 17:00:56 +0300
Message-ID: <20111013140056.GM30887@longonot.mountain>
References: <20110927212810.GA12900@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
To: Steve French <sfrench@samba.org>
Return-path: <samba-technical-bounces@lists.samba.org>
Content-Disposition: inline
In-Reply-To: <20110927212810.GA12900@elgon.mountain>
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

On Wed, Sep 28, 2011 at 12:28:10AM +0300, Dan Carpenter wrote:
> This solves a problem for where a user without write permissions
> was creating empty files.  This function was supposed to do a lookup
> only, the create happens later.
> 

I never heard back on this.

regards,
dan carpenter
