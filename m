From: Jeff Layton via samba <samba@lists.samba.org>
Subject: Re: cifs-utils: regression in (mulituser?) mounting 'CIFS
 VFS: Send error in SessSetup = -126'
Date: Fri, 10 Feb 2017 13:30:11 -0500
Message-ID: <1486751411.4233.21.camel@samba.org>
References: <a13d9992-6be8-6f16-f4cb-98e83d2e140b@physics.wisc.edu>
 <mpsd1erijy1.fsf@aaptelpc.suse.de>
 <60de4c72-5278-04b3-5298-658fd11ad978@physics.wisc.edu>
 <106aff65-99f7-ede5-bc08-160b579abb9f@physics.wisc.edu>
 <1486746542.4233.14.camel@samba.org>
 <284d47c4-a3c7-a2c9-d7d1-e5444308922c@physics.wisc.edu>
 <1486748379.4233.16.camel@samba.org>
Reply-To: Jeff Layton <jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs@vger.kernel.org>, Simo Sorce <ssorce@redhat.com>,
 =?ISO-8859-1?Q?Aur=E9lien?= Aptel <aaptel@suse.com>,
 Nalin Dahyabhai <nalin@redhat.com>
To: Chad William Seys <cwseys@physics.wisc.edu>, samba@lists.samba.org
Return-path: <samba-bounces@lists.samba.org>
In-Reply-To: <1486748379.4233.16.camel@samba.org>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba>,
 <mailto:samba-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba/>
List-Post: <mailto:samba@lists.samba.org>
List-Help: <mailto:samba-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba>,
 <mailto:samba-request@lists.samba.org?subject=subscribe>
Errors-To: samba-bounces@lists.samba.org
Sender: "samba" <samba-bounces@lists.samba.org>
List-Id: linux-cifs.vger.kernel.org

On Fri, 2017-02-10 at 12:39 -0500, Jeff Layton wrote:
> On Fri, 2017-02-10 at 11:15 -0600, Chad William Seys wrote:
> > Hi Jeff,
> > 
> > > So we have a default credcache for the user for whom we are operating
> > > as, but we can't get the default principal name from it. My guess is
> > > that it's not finding the
> > 
> > This mount is run by root UID=0 and seems to be find that credential 
> > cache without problem (earlier in the logs).  The problem seems to come 
> > in when it tries to find the cache for user with UID=1494 .
> > 
> > I'm wondering if the scan of /tmp was helpful for finding caches of 
> > non-same users.
> > 
> > (I'm a little surprised that there is any attempt to find credentials of 
> > the non-root user at mount time - what happens if the non-root user 
> > hasn't kinit-ed yet?  And yet that case worked in the past...)
> > 
> 
> I'm more interested in what the trailing info in your credcache name is.
> In your log output for the working case, there are:
> 
> /tmp/krb5cc_0
> /tmp/krb5cc_1494_sM11PG
> 
> So first one doesn't have that _XXXXXX trailing bit. Maybe cifs.upcall
> is not guessing that piece of the filename correctly?
> 

(cc'ing Nalin, Simo and the linux-cifs ml)

Yeah, it seems pretty likely that that is the problem. My guess is that
the extra stuff on the ccname is coming from pam_krb5, which seems to
want to create a credcache that is session-specific.

You could play with setting a different ccname_template for pam_krb5
that doesn't have the trailing stuff at the end, but it looks like it
won't clean them up on logout if you do that. Caveat emptor.

I'm not sure what the right solution is there. For Simo and Nalin:

The upshot here is that we did a big clean up of the cifs-utils code
recently, to get it out of the business of scanning /tmp for credcaches.
That allows us to have better compatibility with other credcache types
(keyring or whatever), and it was always rather nasty anyway.

pam_krb5 wants to make session-specific credcaches however, and
cifs.upcall can't easily guess them. cifs.upcall is called from the
kernel, so it can't look in the environment or anything to find the
credcache.

What's the right approach to fix this? Are we stuck with scanning /tmp
forever?
-- 
Jeff Layton <jlayton@samba.org>

-- 
To unsubscribe from this list go to the following URL and read the
instructions:  https://lists.samba.org/mailman/options/samba
