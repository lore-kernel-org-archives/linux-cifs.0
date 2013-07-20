From: Scott Lovenberg <scott.lovenberg@gmail.com>
Subject: Re: [PATCH] cifs-utils: Correct max string lengths
Date: Fri, 19 Jul 2013 22:44:22 -0400
Message-ID: <8FB3EB95-C367-4DE7-935C-37C7295F7D53@gmail.com>
References: <1374269172-4964-1-git-send-email-scott.lovenberg@gmail.com>
	<CAH2r5msAt8ZuXYdNzufB3BOah7f2ywyi3EgbS14ahESWe1BMRw@mail.gmail.com>
	<C1A22AEB-8028-4D35-9924-83C9D0DD2D5D@gmail.com>
	<CAH2r5msVGjeJss9vXd-8H3yn58=8q=njTgWjBrssov_MBT-XLg@mail.gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Cc: "sfrench@samba.org" <sfrench@samba.org>,
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
	"gang.chen@asianux.com" <gang.chen@asianux.com>,
	"samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
	"jlayton@redhat.com" <jlayton@redhat.com>
To: Steve French <smfrench@gmail.com>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <CAH2r5msVGjeJss9vXd-8H3yn58=8q=njTgWjBrssov_MBT-XLg@mail.gmail.com>
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

On Jul 19, 2013, at 22:34, Steve French <smfrench@gmail.com> wrote:

> Leaving Max share length at 256 is fine with me
>=20
Works for me. Should this be fixed kernel side?

> On Jul 19, 2013 5:20 PM, "Scott Lovenberg" <scott.lovenberg@gmail.com> wro=
te:
>> On Jul 19, 2013, at 17:51, Steve French <smfrench@gmail.com> wrote:
>>=20
>> > MAX_SHARE_NAME of 80 is not correct.  I verified that Samba supports
>> > much longer (see below), but also found some hits on other servers
>> > with longer limits when searching for this.   Windows CLI does appear
>> > to limit to 80 only in the NET SHARE command (also note that maximum
>> > UNC path is probably limited by MAX_PATH to 32768 characters)
>>=20
>> That appears to be correct. The full length of the path is the ultimate l=
imit.  How would you like to handle this?
>>=20
>> >
>> > On Fri, Jul 19, 2013 at 4:26 PM,  <scott.lovenberg@gmail.com> wrote:
>> >> From: Scott Lovenberg <scott.lovenberg@gmail.com>
>> >>
>> >> The max size of the username, domain, password and share name strings
>> >> are now consistent with the kernel and Microsoft's documentation.
>> >>
>> >> Signed-off-by: Scott Lovenberg <scott.lovenberg@gmail.com>
>> >> ---
>> >> AUTHORS      |  2 ++
>> >> mount.cifs.c | 27 ++++++++++++++++++---------
>> >> 2 files changed, 20 insertions(+), 9 deletions(-)
>> >>
>> >> diff --git a/AUTHORS b/AUTHORS
>> >> index 2807079..2f6a14d 100644
>> >> --- a/AUTHORS
>> >> +++ b/AUTHORS
>> >> @@ -5,5 +5,7 @@ Shirish Pargaonkar <shirishpargaonkar@gmail.com>
>> >> Suresh Jayaraman <sjayaraman@suse.de>
>> >> Pavel Shilovsky <piastry@etersoft.ru>
>> >> Igor Druzhinin <jaxbrigs@gmail.com>
>> >> +Scott Lovenberg <scott.lovenberg@gmail.com>
>> >> +
>> >>
>> >> ...and others.
>> >> diff --git a/mount.cifs.c b/mount.cifs.c
>> >> index 3b2b89e..8d975b3 100644
>> >> --- a/mount.cifs.c
>> >> +++ b/mount.cifs.c
>> >> @@ -83,22 +83,31 @@
>> >> /* max length of mtab options */
>> >> #define MTAB_OPTIONS_LEN 220
>> >>
>> >> -/*
>> >> - * Maximum length of "share" portion of a UNC. I have no idea if this=
 is at
>> >> - * all valid. According to MSDN, the typical max length of any compon=
ent is
>> >> - * 255, so use that here.
>> >> +/*
>> >> + * Max share name, username, password and domain sizes match the kern=
el's
>> >> + * allowances for these string sizes which in turn match Microsoft's
>> >> + * documentation.
>> >>  */
>> >> -#define MAX_SHARE_LEN 256
>> >>
>> >> -/* max length of username (somewhat made up here) */
>> >> -#define MAX_USERNAME_SIZE 32
>> >> +/* Max length of the share name portion of a UNC.  According to Micro=
soft
>> >> + * this is correct for Windows 2000/XP. */
>> >> +#define MAX_SHARE_LEN 80
>> >> +
>> >> +/* Max user name length. */
>> >> +#define MAX_USERNAME_SIZE 256
>> >> +
>> >> +/* Max domain size. */
>> >> +#define MAX_DOMAIN_SIZE 256
>> >> +
>> >> +/* Max password size. */
>> >> +#define MOUNT_PASSWD_SIZE 512
>> >> +
>> >> +
>> >>
>> >> #ifndef SAFE_FREE
>> >> #define SAFE_FREE(x) do { if ((x) !=3D NULL) {free(x); x =3D NULL; } }=
 while (0)
>> >> #endif
>> >>
>> >> -#define MOUNT_PASSWD_SIZE 128
>> >> -#define MAX_DOMAIN_SIZE 64
>> >>
>> >> /*
>> >>  * mount.cifs has been the subject of many "security" bugs that have a=
risen
>> >> --
>> >> 1.8.1.4
>> >
>> >
>> >
>> > --
>> > Thanks,
>> >
>> > Steve
