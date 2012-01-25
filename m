From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: How to use the new multiuser option
Date: Wed, 25 Jan 2012 16:07:01 -0500
Message-ID: <20120125160701.4924ea5b@tlielax.poochiereds.net>
References: <20120125181719.039e1c01@pc213re>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert Euhus <euhus-liste1-RRsrufEBJWcjwdJHFrQ6C0zuTB+3w3uf@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120125181719.039e1c01@pc213re>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 25 Jan 2012 18:17:19 +0100
Robert Euhus <euhus-liste1-RRsrufEBJWcjwdJHFrQ6C0zuTB+3w3uf@public.gmane.org> wrote:

> Hello,
> 
> I am trying to figure out how to make use of the new multiuser option
> in mount.cifs.
> 
> What I am trying to accomplish is that on a server which is joined to
> an AD-Domain every user has access to their part on the shares without
> the need to add an fstab entry for every one of them. If I understood
> correctly this is what the multiuser option is for.
> 

That's correct.

> From what I understand I would have to mount the share (from the
> AD-DC) with some kind of server-account and then every user could just
> access that share while his own Kerberos ticket is used for granting
> permissions.
> 
> My question is now how exactly to do the first part:
> - which kerberos ticket is used?
> - should I use the host Principal created by winbind when I joined the AD?
> I already tried to use it by setting 'kerberos method = secrets and 
> keytab' in the smb.conf and then exporting it to /etc/krb5.keytab. via 
> 'net ads keytab create -U euhus'

In the multiuser case, when you mount, you are essentially mounting
with whatever creds you want root to use. A host key is not generally
what you need though since (IIUC) the AD server won't know how to map
that principal to a user account.

> But I still get:
> --------------------------
> root@goto:~# mount -t cifs -o directio,sec=krb5i,multiuser //dc1.workgroup.intern/test /mnt/test/
> mount error(126): Required key not available Refer to the mount.cifs(8)
> manual page (e.g. man mount.cifs)
> --------------------------
> 
> and in the log I found
> --------------------------
> Jan 25 17:55:12 goto cifs.upcall: key description: cifs.spnego;0;0;3f000000;ver=0x2;host=dc1.workgroup.intern;ip4=130.75.5.220;sec=krb5;uid=0x0;user=root;pid=0x4bca
> Jan 25 17:55:12 goto cifs.upcall: ver=2
> Jan 25 17:55:12 goto cifs.upcall: host=dc1.workgroup.intern
> Jan 25 17:55:12 goto cifs.upcall: ip=130.75.5.220
> Jan 25 17:55:12 goto cifs.upcall: sec=1
> Jan 25 17:55:12 goto cifs.upcall: uid=0
> Jan 25 17:55:12 goto cifs.upcall: user=root
> Jan 25 17:55:12 goto cifs.upcall: pid=19402
> Jan 25 17:55:12 goto cifs.upcall: find_krb5_cc: considering /tmp/krb5cc_101125
> Jan 25 17:55:12 goto cifs.upcall: find_krb5_cc: /tmp/krb5cc_101125 is owned by 101125, not 0

It found a credcache but it's not owned by the correct user.

> Jan 25 17:55:12 goto cifs.upcall: krb5_get_init_creds_keytab: -1765328378

It tried to get a TGT using the keytab, but...

#define KRB5KDC_ERR_C_PRINCIPAL_UNKNOWN          (-1765328378L)

...the KDC doesn't recognize this principal.

> Jan 25 17:55:12 goto cifs.upcall: handle_krb5_mech: getting service ticket for cifs/dc1.workgroup.intern
> Jan 25 17:55:12 goto cifs.upcall: cifs_krb5_get_req: unable to resolve (null) to ccache
> Jan 25 17:55:12 goto cifs.upcall: handle_krb5_mech: failed to obtain service ticket (-1765328245)
> --------------------------
> 
> So it seems like I would somehow have to tell cifs.upcall to use the
> host key stored in /etc/krb5.keytab ?
> 

No, It already tried to, but it didn't work. The KDC didn't like it for
some reason.

> This is my /etc/request-key.conf:
> --------------------------
> #OP     TYPE    DESCRIPTION     CALLOUT INFO    PROGRAM ARG1 ARG2 ARG3 ...
> #====== ======= =============== =============== ===============================
> create  user    debug:*         negate          /bin/keyctl negate %k 30 %S
> create  user    debug:loop:*    *               |/bin/cat
> create  user    debug:*         *               /usr/share/keyutils/request-key-debug.sh %k %d %c %S
> create  cifs.spnego     *       *               /usr/sbin/cifs.upcall -c %k
> create  dns_resolver    *       *               /usr/sbin/cifs.upcall %k
> negate  *       *               *               /bin/keyctl negate %k 30 %S
> --------------------------
> 
> Now I don't know what else to try, so any hints are very much appreciated.
> 
> Thanks a lot.
> 

What you probably want to do first is to verify that the key in the
keytab is usable for getting a TGT. You'll need to do this as root
since root needs to do the initial mount:

    # kinit -k <principal_name>

Once you're able to get a TGT, you should be able to try mounting again
(and it should work).

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
