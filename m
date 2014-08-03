From: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Subject: Re: [PATCH] fs: cifs: cifsencrypt.c: Cleaning up missing
 null-terminate in conjunction with strncpy
Date: Sun, 3 Aug 2014 01:22:54 -0500
Message-ID: <CADT32eJZfdU0NnM3msbuG4Bpf9PgsDQhhknqhipnmwuTiiDfyA@mail.gmail.com>
References: <1406413711-7798-1-git-send-email-rickard_strandqvist@spectrumdigital.se> <CADT32eLts-tdQdHo+W3Zc1wQ6Qz8aS3TmHsm8OxmiF2fmhOW5g@mail.gmail.com>
	<1407000807.1835.14.camel@joe-AO725> <CAFo99gZrTd5+Z_XK+CmhF8ROPZSLGZvwzuwQSwFz5_kGHTAn8w@mail.gmail.com> <1407025666.1835.16.camel@joe-AO725>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Steve French <sfrench@samba.org>, linux-cifs <linux-cifs@vger.kernel.org>, samba-technical <samba-technical@lists.samba.org>, LKML <linux-kernel@vger.kernel.org>,
	Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Joe Perches <joe@perches.com>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <1407025666.1835.16.camel@joe-AO725>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

Joe, Thanks for watching out.

I think this patch is not correct and think also the current LM
authentication code is broken
if the password length exceeds 14 characters.

Reading from Chris Hertel's book (Chapter 15, 15.3.3 Creating the LM
Hash), it says:

The LM Hash is a sixteen byte string, created as follows:

1. The password, as entered by the user, is either padded with nuls
(0x00) or trimmed
    to fourteen (14) bytes.
    * Note that the 14-byte password string is not handled as
null-terminated string.  If the
      user enters 14 or more bytes, the last byte in the modified
string will not be nul.
    * Also note the password is given in the 8-bit OEM character set
(extended ASCII),
      not Unicode.
2. The 14-byte password string is converted to all uppercase.

and so on....


So I thought a (quick) patch like this should be a fix instead but it
does not work against a
Samba server if the strlen(password) is more than 14.

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 4934347..aecb4a0 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -307,7 +307,8 @@ int calc_lanman_hash(const char *password, const char *crypt

        memset(password_with_pad, 0, CIFS_ENCPWD_SIZE);
        if (password)
-               strncpy(password_with_pad, password, CIFS_ENCPWD_SIZE);
+               strncpy(password_with_pad, password,
+                       min_t(unsigned int, strlen(password), 14));

        if (!encrypt && global_secflags & CIFSSEC_MAY_PLNTXT) {
                memcpy(lnm_session_key, password_with_pad,

So there is work to be done in lanman auth code but this patch should
not be included.
So taking back the ack.


On Sat, Aug 2, 2014 at 7:27 PM, Joe Perches <joe@perches.com> wrote:
> On Sun, 2014-08-03 at 01:13 +0200, Rickard Strandqvist wrote:
>> 2014-08-02 19:33 GMT+02:00 Joe Perches <joe@perches.com>:
>> > On Sat, 2014-08-02 at 11:55 -0500, Shirish Pargaonkar wrote:
>> >> Acked-by: Shirish Pargaonkar <spargaonkar@suse.com>
>> > []
>> >> > diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
>> > []
>> >> > @@ -307,7 +307,7 @@ int calc_lanman_hash(const char *password, const char *cryptkey, bool encrypt,
>> >> >
>> >> >         memset(password_with_pad, 0, CIFS_ENCPWD_SIZE);
>> >> >         if (password)
>> >> > -               strncpy(password_with_pad, password, CIFS_ENCPWD_SIZE);
>> >> > +               strncpy(password_with_pad, password, CIFS_ENCPWD_SIZE - 1);
>> >
>> >
>> > Is this always correct?
> []
>> Because password_with_pad gets set to all zeros above, the character,
>> I do not guarantee a copy terminating null.
>> Unless it is so that you do not want any terminating null.
>
> That's the question for Steve and cifs people.
>
