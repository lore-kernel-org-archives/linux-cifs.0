From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: problem when testing recent cifs.upcall
Date: Thu, 23 Feb 2017 07:45:02 -0500
Message-ID: <1487853902.7731.21.camel@samba.org>
References: <20170215161522.17063-1-jlayton@samba.org>
         <20170215161522.17063-3-jlayton@samba.org>
         <d29a36ca-693d-e3c6-9428-90b1ee9bce10@physics.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Chad William Seys <cwseys-JAjqph6Yjy/rea2nFwT0Kw@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <d29a36ca-693d-e3c6-9428-90b1ee9bce10-JAjqph6Yjy/rea2nFwT0Kw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 2017-02-22 at 11:32 -0600, Chad William Seys wrote:
> Hi Jeff,
>    I'm testing the most recent cifs.upcall (most recent commit 
> "cifs.upcall: trim even more capabilities") .
>    I copied cifs.upcall over the one provided in Debian package of 
> cifs-utils 6.6
>    While testing, one of the things I did was destroy my kerberos ticket 
> and then try to enter a directory in which the user did not have a 
> listing in the ACL, except through membership in a group.  I wasn't able 
> to ls the directory (fine).  However, kinit failed.  ls-ing shows that 
> the credential cache kinit tries to create already exists, but is owned 
> by root.  Uh oh.  :)
>    Looks like root must go create a credential cache file with same name 
> instead of just looking for an existing one.
>    The steps are below:
> 
> cwseys:
> # kdestroy
> # cd /
> 
> root:
> # umount /smb
> # umount /smb  # to be sure!
> 
> cwseys:
> # kinit
> Password for cwseys-8oz4Nevp0l1cSxESns1TRQ@public.gmane.org:
> # ls /tmp/krb5cc_* -al
> -rw------- 1 cwseys cwseys  939 Feb 22 11:06 /tmp/krb5cc_1494_sM11PG
> 
> root:
> # mount -t cifs //smb.physics.wisc.edu/smb /smb 
> -osec=krb5,multiuser,username=smbadmin-8oz4Nevp0l1cSxESns1TRQ@public.gmane.org,cruid='0',uid=0 
> --verbose
> 
> cwseys:
> # cd /smb
> # kdestroy
> # ls /tmp/krb5cc_* -al
> [user's credential cache not listed]
> # cd to a directory on which cwseys not listed directly in ACLs (but
> # indirectly as part of a group)
> # cd obs-cos
> # ls
> ls: reading directory '.': Permission denied
> # kerberos cache file created with root owner/group !
> # The file has bytes in it, but not matching the size above. Wonder
> # what's in it... ?
> # ls /tmp/krb5cc_* -al
> -rw------- 1 root   root   1050 Feb 22 11:09 /tmp/krb5cc_1494_sM11PG
> # now cannot kinit
> # kinit
> Password for cwseys-8oz4Nevp0l1cSxESns1TRQ@public.gmane.org:
> kinit: Failed to store credentials: Internal credentials cache error 
> (filename: /tmp/krb5cc_1494_sM11PG) while getting initial credentials
> 
> root:
> # lets look in the credential cache that was created by root.
> # looks like credentials used by root to mount /smb:
> # klist -c /tmp/krb5cc_1494_sM11PG
> Ticket cache: FILE:/tmp/krb5cc_1494_sM11PG
> Default principal: smbadmin-8oz4Nevp0l1cSxESns1TRQ@public.gmane.org
> 
> Valid starting       Expires              Service principal
> 02/22/2017 11:27:41  03/04/2017 11:27:41 
> krbtgt/PHYSICS.WISC.EDU-8oz4Nevp0l1cSxESns1TRQ@public.gmane.org
> 02/22/2017 11:27:41  03/04/2017 11:27:41 
> cifs/smb02.physics.wisc.edu-8oz4Nevp0l1cSxESns1TRQ@public.gmane.org
> 


Let's take this to the linux-cifs mailing list...

To be clear...I assume that you have a keytab set up someplace that has
the smbadmin@ credentials in it, correct? That's the only way that
cifs.upcall would instantiate a new credcache.

It sounds like you're walking into the DFS mount in a task that is
running as root, but that has inherited a KRB5CCNAME environment
variable from a cwseys@ login session.

It might be nice to see the debug level output from syslog, so we can
tell what's actually happening in the upcall. Can you provide that?

Thanks,

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
