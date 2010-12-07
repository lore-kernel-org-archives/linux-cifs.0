From: "Carter, Joel" <JoelC-RAygmcqizRRkKYb1c3iuxNBPR1lH4CV8@public.gmane.org>
Subject: RE: Autofs cifs mounts via Kerberos
Date: Tue, 7 Dec 2010 09:03:13 -0800
Message-ID: <7A014DE1422A694A89BA2CE1F5692DF503831D02@niihau.lionsgate.ca>
References: <7A014DE1422A694A89BA2CE1F5692DF503831D00@niihau.lionsgate.ca> <20101207081239.73227aec@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: "Jeff Layton" <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-class: urn:content-classes:message
In-Reply-To: <20101207081239.73227aec-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Jeff.

Yes I think you are right that it's race condition between the Kerberos
ticket being stored and the automounter attempting to use that ticket.

Thanks for the reminder of sec=krb5 maturity status, I wasn't aware of
that. This is for a production system so I should probably stay away
from it. That said, do you know if this is possible with RHEL5 using
smbfs (sorry - off topic) or should I push this off until we move to
RHEL6? It's not a must have, just trying to make our AD/RHEL integration
as tight as possible. I found your bugzilla entry as well, I'll keep my
eyes on it.

Thanks, Joel.

-----Original Message-----
From: Jeff Layton [mailto:jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org] 
Sent: December-07-10 5:13 AM
To: Carter, Joel
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: Autofs cifs mounts via Kerberos

On Mon, 6 Dec 2010 14:00:28 -0800
"Carter, Joel" <JoelC-RAygmcqizRRkKYb1c3iuxNBPR1lH4CV8@public.gmane.org> wrote:

> Hi there.
> 
> Note - cross-posted to autofs-CPWUtch7KCBzeIdxy0IIJw@public.gmane.org
> 
> I am putting the finishing touches on our AD/LDAP using autofs to
mount
> home directories on a Red Hat 5 box. I have login authentication
working
> great, using both traditional SSH authentication (Linux does
> authentication) and GSSAPI (passes Kerberos tickets directly) for
> single-sign-on. The problem is mounting the home directories. If this
is
> the wrong list for this integration stuff let me know if you know of a
> better candidate.
> 
> Here's my configuration:
> 
> auto.master:
> /home_cifs /etc/auto.cifs --timeout=5
> 
> auto.cifs:
> *
>
-fstype=cifs,sec=krb5,user=&,uid=&,gid=lgtr,file_mode=0644,dir_mode=0755
> ://smb.domain.local/userdata/&
> 
> /etc/request-key.conf:
> ...
> create  cifs.spnego * * /usr/sbin/cifs.upcall %k create  dns_resolver
*
> * /usr/sbin/cifs.upcall %k
> 
> /etc/pam.d/system-auth-ac:
> #%PAM-1.0
> # This file is auto-generated.
> # User changes will be destroyed the next time authconfig is run.
> auth        required      pam_env.so
> auth        sufficient    pam_unix.so nullok try_first_pass
> auth        sufficient    pam_krb5.so
> auth        requisite     pam_succeed_if.so uid >= 500 quiet
> auth        required      pam_deny.so
> 
> account     required      pam_unix.so
> account     sufficient    pam_succeed_if.so uid < 500 quiet
> account     sufficient    pam_krb5.so
> account     required      pam_permit.so
> 
> password    requisite     pam_cracklib.so try_first_pass retry=3
> password    sufficient    pam_unix.so md5 shadow nullok try_first_pass
> use_authtok
> password    required      pam_deny.so
> 
> session     optional      pam_keyinit.so revoke
> session     required      pam_limits.so
> session     [success=1 default=ignore] pam_succeed_if.so service in
> crond quiet use_uid
> session     required      pam_unix.so
> 
> /etc/pam.d/sshd
> #%PAM-1.0
> auth       include      system-auth
> account    required     pam_nologin.so
> account    include      system-auth
> password   include      system-auth
> session    optional     pam_keyinit.so force revoke
> session    include      system-auth
> session    required     pam_loginuid.so
> 
> Every user has their unixHomeDirectory set to /home_cifs/<username>
> 
> The mount doesn't seem to work on login but autofs is working. It
works
> fine once logged in (most of the time but does fail sometimes as well)
> and I change the directory to the home:
> 
> Dec  6 11:57:37 bilbo-rh5 cifs.upcall: key description:
>
cifs.spnego;0;0;3f000000;ver=0x2;host=smb.domain.local;ip4=192.168.1.58;
> sec=mskrb5;uid=0x4e20;user=lguser
> Dec  6 11:57:37 bilbo-rh5 cifs.upcall: find_krb5_cc: considering
> /tmp/krb5cc_20000_BfIUPW5852 Dec  6 11:57:37 bilbo-rh5 cifs.upcall:
> find_krb5_cc: FILE:/tmp/krb5cc_20000_BfIUPW5852 is valid ccache Dec  6
> 11:57:37 bilbo-rh5 cifs.upcall: handle_krb5_mech: getting service
ticket
> for cifs/smb.domain.local Dec  6 11:57:37 bilbo-rh5 cifs.upcall:
> handle_krb5_mech: obtained service ticket Dec  6 11:57:37 bilbo-rh5
> automount[5642]: mount(generic): mounted
> //smb.domain.local/userdata/lguser type cifs on /home_cifs/lguser Dec
6
> 11:57:37 bilbo-rh5 automount[5642]: mounted /home_cifs/lguser
> 
> Klist shows this:
> 12/06/10 12:06:55  12/06/10 21:17:32  cifs/smb.domain.local-Cx6ELD3zwl23NexWsGEg3A@public.gmane.org
>         renew until 12/06/10 22:06:55
> 
> Then I can login without problem until automount expires the mount.
When
> it doesn't work this is what is shown:
> 
> Dec  6 11:59:09 bilbo-rh5 cifs.upcall: key description:
>
cifs.spnego;0;0;3f000000;ver=0x2;host=smb.domain.local;ip4=192.168.1.58;
> sec=mskrb5;uid=0x4e20;user=lguser
> Dec  6 11:59:09 bilbo-rh5 cifs.upcall: handle_krb5_mech: getting
service
> ticket for cifs/smb.domain.local Dec  6 11:59:09 bilbo-rh5
cifs.upcall:
> handle_krb5_mech: failed to obtain service ticket (-1765328189) Dec  6
> 11:59:09 bilbo-rh5 cifs.upcall: handle_krb5_mech: getting service
ticket
> for host/smb.domain.local Dec  6 11:59:09 bilbo-rh5 cifs.upcall:
> handle_krb5_mech: failed to obtain service ticket (-1765328189) Dec  6

$ grep 1765328189 /usr/include/krb5/krb5.h 
#define KRB5_FCC_NOFILE                          (-1765328189L)

...which means that cifs.upcall couldn't find the credential cache for
that UID (20000).

Yes, it would be nice to pretty-print that error, but I'm not sure
what kerberos function does that.

> 11:59:09 bilbo-rh5 kernel:  CIFS VFS: cifs_mount failed w/return code
=
> -126 Dec  6 11:59:09 bilbo-rh5 automount[5642]: >> Refer to the
> mount.cifs(8) manual page (e.g. man mount.cifs) Dec  6 11:59:09
> bilbo-rh5 automount[5642]: mount(generic): failed to mount
> //smb.domain.local/userdata/lguser (type cifs) on /home_cifs/lguser
Dec
> 6 11:59:09 bilbo-rh5 automount[5642]: failed to mount
/home_cifs/lguser
> 
> I have wireshark traces as well for success and non-success.
> 

I doubt that'll tell you much. I think the problem is with kerberos.
Maybe you have a race condition between the creation of the credential
cache and the automount being triggered? That's probably where I'd
focus my efforts...

For an FYI, the sec=krb5 code is still "tech-preview" in RHEL5. There
are some differences between the implementation there and the one in
RHEL6.

I'm hoping to get multiuser mounts into RHEL6.1, which will mean that
you can do away with autofs here and just mount "userdata" on
"/home_cifs" in this configuration. Each user will be able to use their
own credentials when accessing the mount. That should be a lot simpler
and less "fiddly" than autofs for this configuration.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
