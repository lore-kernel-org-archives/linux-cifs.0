From: Jeff Layton <jlayton@samba.org>
Subject: cifs-utils release 6.7 ready for download
Date: Thu, 02 Mar 2017 13:44:57 -0500
Message-ID: <1488480297.2892.2.camel@samba.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
 protocol="application/pgp-signature"; boundary="=-BWW9O5hjAUyRaIJuNSCs"
Cc: Germano Percossi <germano.percossi@citrix.com>
To: linux-cifs <linux-cifs@vger.kernel.org>, "samba-technical@lists.samba.org"
 <samba-technical@lists.samba.org>, samba <samba@lists.samba.org>
Return-path: <samba-technical-bounces@lists.samba.org>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
 <mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical/>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
 <mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Errors-To: samba-technical-bounces@lists.samba.org
Sender: "samba-technical" <samba-technical-bounces@lists.samba.org>
List-Id: linux-cifs.vger.kernel.org


--=-BWW9O5hjAUyRaIJuNSCs
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The main change in this release is to address some regressions that
crept in when we switched to a scheme that does not rely on walking /tmp
to look for credcaches.

We now will use the information from the kernel about the initiating
pid, reach into that task's environment and scrape out the $KRB5CCNAME
variable. This can be problematic in setuid situations, so we avoid
doing that for the root user. It's not a perfect scheme but it's
certainly better than what was there before.

There are also some mount.cifs cleanups and fixes from Germano Percossi.

webpage:=C2=A0=C2=A0=C2=A0=C2=A0https://wiki.samba.org/index.php/LinuxCIFS_=
utils
tarball:=C2=A0=C2=A0=C2=A0=C2=A0ftp://ftp.samba.org/pub/linux-cifs/cifs-uti=
ls/
git:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0git://git.samba.org/cif=
s-utils.git
gitweb:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0http://git.samba.org/?p=3Dcifs-utils.g=
it;a=3Dsummary

Detailed list of changes since 6.6 was released:

commit c4e51e4dcbd3169638fa3fb13df61fa1fee525a8
Author: Jeff Layton <jlayton@samba.org>
Date:=C2=A0=C2=A0=C2=A0Sun Nov 27 06:28:29 2016 -0500

=C2=A0=C2=A0=C2=A0=C2=A0cifs-utils: bump version to 6.6.1 for pre-release b=
uilds
=C2=A0=C2=A0=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0Signed-off-by: Jeff Layton <jlayton@samba.org>

commit 76da9405575d484b33eb4e56466366c8dbe87046
Author: Germano Percossi <germano.percossi@citrix.com>
Date:=C2=A0=C2=A0=C2=A0Fri Nov 18 18:54:49 2016 +0000

=C2=A0=C2=A0=C2=A0=C2=A0mount.cifs: Removed extra comma in front of domain
=C2=A0=C2=A0=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0Signed-off-by: Germano Percossi <germano.percossi@c=
itrix.com>

commit 57e4e22de7ea79f56471e7eb8cec9db926087f8d
Author: Germano Percossi <germano.percossi@citrix.com>
Date:=C2=A0=C2=A0=C2=A0Fri Nov 18 18:54:50 2016 +0000

=C2=A0=C2=A0=C2=A0=C2=A0mount.cifs: Accept empty domains on the command lin=
e
=C2=A0=C2=A0=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0If we do not allow empty domains on the command lin=
e we are preventing
=C2=A0=C2=A0=C2=A0=C2=A0the kernel module from taking different actions if =
the domain has not
=C2=A0=C2=A0=C2=A0=C2=A0been specified at all or just passed empty.
=C2=A0=C2=A0=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0In fact, with this fix the cifs module behaves diff=
erently once an empty
=C2=A0=C2=A0=C2=A0=C2=A0domain is passed: the find_domain_name function is =
not invoked when an
=C2=A0=C2=A0=C2=A0=C2=A0empty domain is passed.
=C2=A0=C2=A0=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0It is possible to pass both 'domain=3D' or 'domain=
=3D""' even though the
=C2=A0=C2=A0=C2=A0=C2=A0kernel module will accept the former only when asso=
ciated with the
=C2=A0=C2=A0=C2=A0=C2=A0sloppy option.
=C2=A0=C2=A0=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0Signed-off-by: Germano Percossi <germano.percossi@c=
itrix.com>

commit a1f3acd40b265f134a97a739a6898b3958d206b9
Author: Germano Percossi <germano.percossi@citrix.com>
Date:=C2=A0=C2=A0=C2=A0Fri Nov 18 18:54:51 2016 +0000

=C2=A0=C2=A0=C2=A0=C2=A0mount.cifs: Fixed command line parsing and aligned =
with kernel
=C2=A0=C2=A0=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0The way token matching was done was consuming the p=
arameters namespace
=C2=A0=C2=A0=C2=A0=C2=A0quickly.=C2=A0=C2=A0For example, anything starting =
with "dom" was interpreted with
=C2=A0=C2=A0=C2=A0=C2=A0domain, while it could have been a completely diffe=
rent word.=C2=A0=C2=A0The same
=C2=A0=C2=A0=C2=A0=C2=A0is true even for "ro".
=C2=A0=C2=A0=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0Moreover, many perfectly valid options like "addr" =
where not accepted.
=C2=A0=C2=A0=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0The cifs=C2=A0=C2=A0kernel module is very strict wh=
en it comes to names: 'dom' and
=C2=A0=C2=A0=C2=A0=C2=A0'domain' are valid while 'domai' is not, so the use=
rspace tool needs to
=C2=A0=C2=A0=C2=A0=C2=A0comply otherwise it becomes very difficult to come =
up with new names for
=C2=A0=C2=A0=C2=A0=C2=A0options.
=C2=A0=C2=A0=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0Now, checking is strict and as close as possible to=
 kernel.=C2=A0=C2=A0When it is
=C2=A0=C2=A0=C2=A0=C2=A0not, it is just to avoid breaking compatibility wit=
h some users.
=C2=A0=C2=A0=C2=A0=C2=A0However, workg has been removed because it is too l=
azy and undocumented.
=C2=A0=C2=A0=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0The only variable left without strict checking is '=
x-' because the
=C2=A0=C2=A0=C2=A0=C2=A0intent is to ignore anything starting in that way
=C2=A0=C2=A0=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0Signed-off-by: Germano Percossi <germano.percossi@c=
itrix.com>

commit 743301da5bf502197beb1f91f98e11eea9070e4e
Author: Germano Percossi <germano.percossi@citrix.com>
Date:=C2=A0=C2=A0=C2=A0Fri Nov 18 18:54:52 2016 +0000

=C2=A0=C2=A0=C2=A0=C2=A0mount.cifs: Remove unneeded stdbool header include
=C2=A0=C2=A0=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0Signed-off-by: Germano Percossi <germano.percossi@c=
itrix.com>

commit d73a52e50d43f07638f34cb860e9824a932508b8
Author: Sachin Prabhu <sprabhu@redhat.com>
Date:=C2=A0=C2=A0=C2=A0Wed Jan 4 07:45:17 2017 -0500

=C2=A0=C2=A0=C2=A0=C2=A0manpage: document mfsymlinks in the mount.cifs man =
page
=C2=A0=C2=A0=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0Information from the cifs README in the kernel sour=
ces is used.
=C2=A0=C2=A0=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0Signed-off-by: Sachin Prabhu <sprabhu@redhat.com>

commit fb7693c50e99f2153500bb3590602993016051b4
Author: Jeff Layton <jlayton@samba.org>
Date:=C2=A0=C2=A0=C2=A0Sun Feb 12 09:36:12 2017 -0500

=C2=A0=C2=A0=C2=A0=C2=A0cifs.upcall: convert two flags from int to bool
=C2=A0=C2=A0=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0Signed-off-by: Jeff Layton <jlayton@samba.org>

commit a6662edb12b267e12bd67424e485ca081a97beb3
Author: Jeff Layton <jlayton@samba.org>
Date:=C2=A0=C2=A0=C2=A0Mon Feb 13 08:33:02 2017 -0500

=C2=A0=C2=A0=C2=A0=C2=A0cifs.upcall: switch group IDs when handling an upca=
ll
=C2=A0=C2=A0=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0Currently, we leave the group ID alone, but in a la=
ter patch we'll be
=C2=A0=C2=A0=C2=A0=C2=A0changing cifs.upcall to scrape $KRB5CCNAME out of t=
he originating
=C2=A0=C2=A0=C2=A0=C2=A0process. At that point, we want to be a little more=
 careful with the
=C2=A0=C2=A0=C2=A0=C2=A0process credentials we'll be using.
=C2=A0=C2=A0=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0After we get the uid, do a getpwuid and grab the de=
fault gid for the
=C2=A0=C2=A0=C2=A0=C2=A0user. Then use setgid to set it before calling setu=
id.
=C2=A0=C2=A0=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0Signed-off-by: Jeff Layton <jlayton@samba.org>

commit 109c189bf4720b0d7ed43113e1e26c89c8b15ada
Author: Jeff Layton <jlayton@samba.org>
Date:=C2=A0=C2=A0=C2=A0Wed Feb 15 10:00:45 2017 -0500

=C2=A0=C2=A0=C2=A0=C2=A0cifs.upcall: drop capabilities early in program
=C2=A0=C2=A0=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0Much of cifs.upcall can and should be run without e=
levated privileges.
=C2=A0=C2=A0=C2=A0=C2=A0On entry into the program, drop as many capabilitie=
s as we can get away
=C2=A0=C2=A0=C2=A0=C2=A0with, and then always drop any remaining caps after=
 calling setuid().
=C2=A0=C2=A0=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0Signed-off-by: Jeff Layton <jlayton@samba.org>

commit ed97e4ecab4e9a103c46232785fb76b3f07d0637
Author: Jeff Layton <jlayton@samba.org>
Date:=C2=A0=C2=A0=C2=A0Sat Feb 11 08:38:46 2017 -0500

=C2=A0=C2=A0=C2=A0=C2=A0cifs.upcall: allow scraping of KRB5CCNAME out of in=
itiating task's /proc/<pid>/environ file
=C2=A0=C2=A0=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0Chad reported that he was seeing a regression in ci=
fs-utils-6.6. Prior
=C2=A0=C2=A0=C2=A0=C2=A0to that, cifs.upcall was able to find credcaches in=
 non-default FILE:
=C2=A0=C2=A0=C2=A0=C2=A0locations, but with the rework of that code, that a=
bility was lost.
=C2=A0=C2=A0=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0Unfortunately, the krb5 library design doesn't real=
ly take into account
=C2=A0=C2=A0=C2=A0=C2=A0the fact that we might need to find a credcache in =
a process that isn't
=C2=A0=C2=A0=C2=A0=C2=A0descended from the session.
=C2=A0=C2=A0=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0When the kernel does an upcall, it passes several b=
its of info about the
=C2=A0=C2=A0=C2=A0=C2=A0task that initiated the upcall. One of those things=
 is the PID (the
=C2=A0=C2=A0=C2=A0=C2=A0tgid, in particular). We can use that info to reach=
 into the
=C2=A0=C2=A0=C2=A0=C2=A0/proc/<pid>/environ file for the process, and grab =
whatever value of
=C2=A0=C2=A0=C2=A0=C2=A0$KRB5CCNAME is there.
=C2=A0=C2=A0=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0Then, after switching credentials, set $KRB5CCNAME =
in the environment
=C2=A0=C2=A0=C2=A0=C2=A0to the same value before opening the credcache, to =
hint to the krb5
=C2=A0=C2=A0=C2=A0=C2=A0libs where they ought to look.
=C2=A0=C2=A0=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0This new behavior is on by default, but can be disa=
bled by having
=C2=A0=C2=A0=C2=A0=C2=A0request-key pass a '-E' flag to cifs.upcall.
=C2=A0=C2=A0=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0Reported-by: Chad William Seys <cwseys@physics.wisc=
.edu>
=C2=A0=C2=A0=C2=A0=C2=A0Signed-off-by: Jeff Layton <jlayton@samba.org>

commit ec3874fdc669901f4a9e8a90a856f999cd627a3f
Author: Jeff Layton <jlayton@samba.org>
Date:=C2=A0=C2=A0=C2=A0Thu Feb 16 09:55:45 2017 -0500

=C2=A0=C2=A0=C2=A0=C2=A0cifs.upcall: trim even more capabilities
=C2=A0=C2=A0=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0We really only need CAP_DAC_READ_SEARCH, not CAP_DA=
C_OVERRIDE, and
=C2=A0=C2=A0=C2=A0=C2=A0only when we are going to probe the environ file.
=C2=A0=C2=A0=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0Also, fix the non-libcap-ng trim_capabilities proto=
type.
=C2=A0=C2=A0=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0Reviewed-by: Simo Sorce <simo@redhat.com>
=C2=A0=C2=A0=C2=A0=C2=A0Signed-off-by: Jeff Layton <jlayton@samba.org>

commit 912cbe49114392bd7c375c4c37698d406eb0660e
Author: Jeff Layton <jlayton@samba.org>
Date:=C2=A0=C2=A0=C2=A0Thu Feb 23 18:49:59 2017 -0500

=C2=A0=C2=A0=C2=A0=C2=A0data_blob: remove need for replace.h
=C2=A0=C2=A0=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0We only need ZERO_STRUCT there.
=C2=A0=C2=A0=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0Signed-off-by: Jeff Layton <jlayton@samba.org>

commit ebdd0a9d9745f19a13415a65914dcc9993f28e96
Author: Jeff Layton <jlayton@samba.org>
Date:=C2=A0=C2=A0=C2=A0Thu Feb 23 20:56:27 2017 -0500

=C2=A0=C2=A0=C2=A0=C2=A0spengo.c/asn1.c: remove need for replace.h
=C2=A0=C2=A0=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0Just need stdbool.h instead.
=C2=A0=C2=A0=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0Signed-off-by: Jeff Layton <jlayton@samba.org>

commit 4849f9fc118bf074ce5efea94fa0c4727a430863
Author: Jeff Layton <jlayton@samba.org>
Date:=C2=A0=C2=A0=C2=A0Thu Feb 23 18:58:17 2017 -0500

=C2=A0=C2=A0=C2=A0=C2=A0cifs.upcall: remove need for replace.h
=C2=A0=C2=A0=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0Take just what we need from replace.h and move it t=
o cifs.upcall.c.
=C2=A0=C2=A0=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0Signed-off-by: Jeff Layton <jlayton@samba.org>

commit 2333c502f81c66e186123e1b739a056fb049d5e4
Author: Jeff Layton <jlayton@samba.org>
Date:=C2=A0=C2=A0=C2=A0Thu Feb 23 19:21:56 2017 -0500

=C2=A0=C2=A0=C2=A0=C2=A0replace.h: remove it
=C2=A0=C2=A0=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0Nothing uses it now.
=C2=A0=C2=A0=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0Signed-off-by: Jeff Layton <jlayton@samba.org>

commit 4850d321c3ec8f1b31b162fe8a316a7638c12b94
Author: Jeff Layton <jlayton@samba.org>
Date:=C2=A0=C2=A0=C2=A0Thu Feb 23 19:09:12 2017 -0500

=C2=A0=C2=A0=C2=A0=C2=A0treewide: Eliminate SAFE_FREE
=C2=A0=C2=A0=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0It just frees and then zeroes out the pointer. That=
's of dubious
=C2=A0=C2=A0=C2=A0=C2=A0value in the places where it's currently being used=
. Just use
=C2=A0=C2=A0=C2=A0=C2=A0free() instead.
=C2=A0=C2=A0=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0Signed-off-by: Jeff Layton <jlayton@samba.org>

commit 891d7806ac153e7d99b324ed9a33ff92699a92c6
Author: Jeff Layton <jlayton@samba.org>
Date:=C2=A0=C2=A0=C2=A0Thu Feb 23 19:14:07 2017 -0500

=C2=A0=C2=A0=C2=A0=C2=A0data_blob: Eliminate _PUBLIC_
=C2=A0=C2=A0=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0It's defined to nothing anyway.
=C2=A0=C2=A0=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0Signed-off-by: Jeff Layton <jlayton@samba.org>

commit 2dcecd21262513a0866c321643fc33d3d0135915
Author: Jeff Layton <jlayton@samba.org>
Date:=C2=A0=C2=A0=C2=A0Thu Feb 23 18:28:24 2017 -0500

=C2=A0=C2=A0=C2=A0=C2=A0cifs.upcall: unset $KRB5CCNAME when creating new cr=
edcache from keytab
=C2=A0=C2=A0=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0We don't want to trust $KRB5CCNAME when creating or=
 updating a new
=C2=A0=C2=A0=C2=A0=C2=A0credcache since we could be operating under the wro=
ng credentials.
=C2=A0=C2=A0=C2=A0=C2=A0Always create new credcaches in the default locatio=
n instead.
=C2=A0=C2=A0=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0Reported-by: Chad William Seys <cwseys@physics.wisc=
.edu>
=C2=A0=C2=A0=C2=A0=C2=A0Signed-off-by: Jeff Layton <jlayton@samba.org>

commit 9eaa21ed37126d1bfcb998b4c8f6115ac77e9b5f
Author: Jeff Layton <jlayton@samba.org>
Date:=C2=A0=C2=A0=C2=A0Thu Feb 23 16:50:43 2017 -0500

=C2=A0=C2=A0=C2=A0=C2=A0cifs.upcall: don't do env scraping when uid is 0
=C2=A0=C2=A0=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0Setuid programs triggering upcalls could trick the =
program here. Also,
=C2=A0=C2=A0=C2=A0=C2=A0the d_automount method is done with credentials ove=
rridden so if you
=C2=A0=C2=A0=C2=A0=C2=A0can end up with mismatched creds and env vars due t=
o that as well.
=C2=A0=C2=A0=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0It's a hack, but the only recourse I can see is to =
avoid doing this
=C2=A0=C2=A0=C2=A0=C2=A0when the uid is 0. That means we can't rely on find=
ing root credcaches
=C2=A0=C2=A0=C2=A0=C2=A0in alternate locations using $KRB5CCNAME, but I thi=
nk that's the best
=C2=A0=C2=A0=C2=A0=C2=A0we can do.
=C2=A0=C2=A0=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0Reported-and-Tested-by: Chad William Seys <cwseys@p=
hysics.wisc.edu>
=C2=A0=C2=A0=C2=A0=C2=A0Signed-off-by: Jeff Layton <jlayton@samba.org>

commit 69949ba0086ac7a4f07ade7558fbe5c537220ebb
Author: Jeff Layton <jlayton@samba.org>
Date:=C2=A0=C2=A0=C2=A0Fri Feb 24 10:48:57 2017 -0500

=C2=A0=C2=A0=C2=A0=C2=A0cifs.upcall: use a MEMORY: ccache when instantiatin=
g from a keytab
=C2=A0=C2=A0=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0Using a more permanent ccache is potentially proble=
matic when we're
=C2=A0=C2=A0=C2=A0=C2=A0instantiating a new one. We might be operating unde=
r different creds
=C2=A0=C2=A0=C2=A0=C2=A0than expected. Just use a MEMORY: ccache since we d=
on't need it to
=C2=A0=C2=A0=C2=A0=C2=A0last longer than the life of the upcall anyway.
=C2=A0=C2=A0=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0Reported-and-Tested-by: Chad William Seys <cwseys@p=
hysics.wisc.edu>
=C2=A0=C2=A0=C2=A0=C2=A0Signed-off-by: Jeff Layton <jlayton@samba.org>

commit 8101a07871f185c7044fa2ca221b282ab4607c8b
Author: Jeff Layton <jlayton@samba.org>
Date:=C2=A0=C2=A0=C2=A0Thu Mar 2 11:51:05 2017 -0500

=C2=A0=C2=A0=C2=A0=C2=A0cifs-utils: bump version to 6.7
=C2=A0=C2=A0=C2=A0=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0Signed-off-by: Jeff Layton <jlayton@samba.org>


--=20
Jeff Layton <jlayton@samba.org>
--=-BWW9O5hjAUyRaIJuNSCs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIvBAABCAAZBQJYuGgpEhxqbGF5dG9uQHNhbWJhLm9yZwAKCRAADmhBGVaCFTsY
D/9KKw7iLWgm1IC4WVd3fhfCd+0cYXalt8jfgH4gvgLvcX13S1BrnHBQqY9/OpY8
nekIB9wjzjj8W/6GGmb8fJJaB82/e9pO7J9SjvemV7Kpuw3iQX9VW1oKYGIgBWiB
tFewRulisa1oek0cbbSDON3ddktBLLacwHnv+/ocd6b7ixyvt2MxObzuC5UmIHKG
q8u1iFm1p75xgBojGEhrkghuxkLnuUespEEBgXxU+O/IE51WN+yWXfAI3cH60zmT
DZhuqUIyfyIZfYSkosB6kAcSJOtILByS6gPKoRuiujKXJeeamV0v1TxgN1Z2DRyD
T96z2AJ7iOZqIqcqJTEI2nEFpnUeK4AxO/EXAT8+l0y+097aATszQtlO0S/LqbKH
RO+wy/joxmXJsC0pF0PVojp9/jggRokBhAZc3Fgw7bp5PKd/apZx1gOEbE/uywKH
lwTgwbOVRbIPQO/l3HP6nSwAXUj79YCG+N2BNjT6pv9sDsFyK5i5wzoY+gHpDtJ4
bQjPa9uBITOvzVJ2LTUyNchA5YC6B9pw5QrsUHY9FhOgr44ceoSRWpR8D977Iayz
q8zG0Uhv3/4PlIFcsp56JapQpYjGdMK8LCcZgQQGq2qzPbMrepWp1rHTXYx6DPs8
IvGShqTiOKOfgx4ldOv35CkepPjxJmWPOpJ3gIJHn/l6UA==
=s9ca
-----END PGP SIGNATURE-----

--=-BWW9O5hjAUyRaIJuNSCs--
