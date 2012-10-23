From: Jeff Layton <jlayton@redhat.com>
Subject: Re: CIFS: Deprecating NFS mounting syntax in mount.cifs
Date: Tue, 23 Oct 2012 13:02:38 -0400
Message-ID: <20121023130238.6100255d@corrin.poochiereds.net>
References: <1350583669-12118-1-git-send-email-scott.lovenberg@gmail.com>
	<5086BE25.8080102@gmail.com> <5086CA29.8030305@steve-ss.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: samba@lists.samba.org, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org, smfrench@gmail.com
To: steve <steve@steve-ss.com>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <5086CA29.8030305@steve-ss.com>
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

On Tue, 23 Oct 2012 18:47:37 +0200
steve <steve@steve-ss.com> wrote:

> On 10/23/2012 05:56 PM, Scott Lovenberg wrote:
> > On 10/18/2012 2:07 PM, scott.lovenberg@gmail.com wrote:
> > no one has objected (or really said anything).  Can we merge this patch?
> > --
> Hi
> I'm just trying to represent users. Can we take this to user level by 
> giving an example of what will work and what will not work after the patch?
> 
> For example, the Linux automounter.
> 
> Currently, we have this map:
> * -fstype=cifs,rw,sec=krb5 ://myserver/myshare/&
> 

Does that really work? What purpose does the ':' serve there? That
should probably be removed. I doubt we'd end up breaking that syntax,
but I can't be certain.

> Are you talking about the difference between that and this:
> * -fstype=cifs,rw,sec=krb5 myserver:/myshare/&

Right, the above syntax would no longer work after the change.

> 
> Question: will I need to change anything due to this patch?
> 

For this patch, you don't need to do anything. It just adds a warning.
Eventually though, nfs-style "devicenames" would no longer work for
cifs mounts. For your map above, you probably want something like:

* -fstype=cifs,rw,sec=krb5 //myserver/myshare/&

(i.e. get rid of the extraneous ':').
-- 
Jeff Layton <jlayton@redhat.com>
