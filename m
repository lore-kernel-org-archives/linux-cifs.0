From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/8] cifs: Fix removexattr for os2.* xattrs
Date: Wed, 13 Apr 2016 23:27:47 -0500
Message-ID: <CAH2r5msk0F1v-tiN=-cd-f5Kq=5nhyu7E7DwTCZUVYGiOL0H1Q@mail.gmail.com>
References: <20160413182026.GR25498@ZenIV.linux.org.uk> <1460586620-5717-1-git-send-email-agruenba@redhat.com>
 <1460586620-5717-4-git-send-email-agruenba@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=f46d04289bc92ff30505306a521c
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1460586620-5717-4-git-send-email-agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--f46d04289bc92ff30505306a521c
Content-Type: text/plain; charset=UTF-8

merged into cifs-2.6.git

checkpatch complained about comment formatting so I cleaned that up in
attached trivial followon patch.

On Wed, Apr 13, 2016 at 5:30 PM, Andreas Gruenbacher
<agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> If cifs_removexattr finds a "user." or "os2." xattr name prefix, it
> skips 5 bytes, one byte too many for "os2.".
>
> Signed-off-by: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/xattr.c | 26 +++++++++++++++++---------
>  1 file changed, 17 insertions(+), 9 deletions(-)
>
> diff --git a/fs/cifs/xattr.c b/fs/cifs/xattr.c
> index 6e73ba9..721c6db 100644
> --- a/fs/cifs/xattr.c
> +++ b/fs/cifs/xattr.c
> @@ -61,15 +61,7 @@ int cifs_removexattr(struct dentry *direntry, const char *ea_name)
>         }
>         if (ea_name == NULL) {
>                 cifs_dbg(FYI, "Null xattr names not supported\n");
> -       } else if (strncmp(ea_name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN)
> -               && (strncmp(ea_name, XATTR_OS2_PREFIX, XATTR_OS2_PREFIX_LEN))) {
> -               cifs_dbg(FYI,
> -                        "illegal xattr request %s (only user namespace supported)\n",
> -                        ea_name);
> -               /* BB what if no namespace prefix? */
> -               /* Should we just pass them to server, except for
> -               system and perhaps security prefixes? */
> -       } else {
> +       } else if (!strncmp(ea_name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN)) {
>                 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
>                         goto remove_ea_exit;
>
> @@ -78,6 +70,22 @@ int cifs_removexattr(struct dentry *direntry, const char *ea_name)
>                         rc = pTcon->ses->server->ops->set_EA(xid, pTcon,
>                                 full_path, ea_name, NULL, (__u16)0,
>                                 cifs_sb->local_nls, cifs_remap(cifs_sb));
> +       } else if (!strncmp(ea_name, XATTR_OS2_PREFIX, XATTR_OS2_PREFIX_LEN)) {
> +               if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
> +                       goto remove_ea_exit;
> +
> +               ea_name += XATTR_OS2_PREFIX_LEN; /* skip past os2. prefix */
> +               if (pTcon->ses->server->ops->set_EA)
> +                       rc = pTcon->ses->server->ops->set_EA(xid, pTcon,
> +                               full_path, ea_name, NULL, (__u16)0,
> +                               cifs_sb->local_nls, cifs_remap(cifs_sb));
> +       } else {
> +               cifs_dbg(FYI,
> +                        "illegal xattr request %s (only user namespace supported)\n",
> +                        ea_name);
> +               /* BB what if no namespace prefix? */
> +               /* Should we just pass them to server, except for
> +               system and perhaps security prefixes? */
>         }
>  remove_ea_exit:
>         kfree(full_path);
> --
> 2.4.11
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve

--f46d04289bc92ff30505306a521c
Content-Type: application/mbox;
	name="0001-CIFS-Fix-formatting-issues-on-previous-patches-spott.patch"
Content-Disposition: attachment;
	filename="0001-CIFS-Fix-formatting-issues-on-previous-patches-spott.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_imzsc7iq0

RnJvbSA0M2I3NWM0NDczYzI0YTM3MTM0MDAxMTFiNWI3MDZiMTQ4YWY1YjBiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHNtZnJlbmNoQGdtYWlsLmNvbT4KRGF0
ZTogV2VkLCAxMyBBcHIgMjAxNiAyMzoxODo0NSAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIENJRlM6
IEZpeCBmb3JtYXR0aW5nIGlzc3VlcyBvbiBwcmV2aW91cyBwYXRjaGVzIHNwb3R0ZWQgYnkKIGNo
ZWNrcGF0Y2gKClRyaXZpYWwgY2hhbmdlLgoKT25lIGJsb2NrIGNvbW1lbnQgZnJvbSBwcmV2aW91
cyBwYXRjaCBoYWQgd3JvbmcgZm9ybWF0LCBhbmQgZXhpc3RpbmcKeGF0dHIgY29kZSBoYWQgaW5j
b3JyZWN0IGluZGVudGF0aW9uIGluIG9uZSBmdW5jdGlvbiAtIHRoZSBjaGVja3BhdGNoCm9uIHRo
ZSByZWNlbnQgcGF0Y2hlcyBmcm9tIEFuZHJlYXMgc3BvdHRlZCBpdC4gIE1ha2UgY2hlY2twYXRj
aApoYXBweS4KClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RldmUuZnJlbmNoQHByaW1h
cnlkYXRhLmNvbT4KQ0M6IEFuZHJlYXMgR3J1ZW5iYWNoZXIgPGFncnVlbmJhQHJlZGhhdC5jb20+
Ci0tLQogZnMvY2lmcy94YXR0ci5jIHwgNTIgKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDI3IGluc2VydGlvbnMoKyks
IDI1IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMveGF0dHIuYyBiL2ZzL2NpZnMv
eGF0dHIuYwppbmRleCBhZjJiNWJlLi5iNmU0NjhjIDEwMDY0NAotLS0gYS9mcy9jaWZzL3hhdHRy
LmMKKysrIGIvZnMvY2lmcy94YXR0ci5jCkBAIC0yMjEsOSArMjIxLDExIEBAIGludCBjaWZzX3Nl
dHhhdHRyKHN0cnVjdCBkZW50cnkgKmRpcmVudHJ5LCBjb25zdCBjaGFyICplYV9uYW1lLAogCQl9
IGVsc2UgewogCQkJY2lmc19kYmcoRllJLCAiaWxsZWdhbCB4YXR0ciByZXF1ZXN0ICVzIChvbmx5
IHVzZXIgbmFtZXNwYWNlIHN1cHBvcnRlZClcbiIsCiAJCQkJIGVhX25hbWUpOwotCQkgIC8qIEJC
IHdoYXQgaWYgbm8gbmFtZXNwYWNlIHByZWZpeD8gKi8KLQkJICAvKiBTaG91bGQgd2UganVzdCBw
YXNzIHRoZW0gdG8gc2VydmVyLCBleGNlcHQgZm9yCi0JCSAgc3lzdGVtIGFuZCBwZXJoYXBzIHNl
Y3VyaXR5IHByZWZpeGVzPyAqLworCQkJLyoKKwkJCSAqIEJCIHdoYXQgaWYgbm8gbmFtZXNwYWNl
IHByZWZpeD8KKwkJCSAqIFNob3VsZCB3ZSBqdXN0IHBhc3MgdGhlbSB0byBzZXJ2ZXIsIGV4Y2Vw
dCBmb3IKKwkJCSAqIHN5c3RlbSBhbmQgcGVyaGFwcyBzZWN1cml0eSBwcmVmaXhlcz8KKwkJCSAq
LwogCQl9CiAJfQogCkBAIC0zMTcsMzAgKzMxOSwzMCBAQCBzc2l6ZV90IGNpZnNfZ2V0eGF0dHIo
c3RydWN0IGRlbnRyeSAqZGlyZW50cnksIGNvbnN0IGNoYXIgKmVhX25hbWUsCiAjZW5kaWYgLyog
Q09ORklHX0NJRlNfUE9TSVggKi8KIAl9IGVsc2UgaWYgKHN0cmNtcChlYV9uYW1lLCBDSUZTX1hB
VFRSX0NJRlNfQUNMKSA9PSAwKSB7CiAjaWZkZWYgQ09ORklHX0NJRlNfQUNMCi0JCQl1MzIgYWNs
bGVuOwotCQkJc3RydWN0IGNpZnNfbnRzZCAqcGFjbDsKLQotCQkJaWYgKHBUY29uLT5zZXMtPnNl
cnZlci0+b3BzLT5nZXRfYWNsID09IE5VTEwpCi0JCQkJZ290byBnZXRfZWFfZXhpdDsgLyogcmMg
YWxyZWFkeSBFT1BOT1RTVVBQICovCi0KLQkJCXBhY2wgPSBwVGNvbi0+c2VzLT5zZXJ2ZXItPm9w
cy0+Z2V0X2FjbChjaWZzX3NiLAotCQkJCQlkX2lub2RlKGRpcmVudHJ5KSwgZnVsbF9wYXRoLCAm
YWNsbGVuKTsKLQkJCWlmIChJU19FUlIocGFjbCkpIHsKLQkJCQlyYyA9IFBUUl9FUlIocGFjbCk7
Ci0JCQkJY2lmc19kYmcoVkZTLCAiJXM6IGVycm9yICV6ZCBnZXR0aW5nIHNlYyBkZXNjXG4iLAot
CQkJCQkgX19mdW5jX18sIHJjKTsKLQkJCX0gZWxzZSB7Ci0JCQkJaWYgKGVhX3ZhbHVlKSB7Ci0J
CQkJCWlmIChhY2xsZW4gPiBidWZfc2l6ZSkKLQkJCQkJCWFjbGxlbiA9IC1FUkFOR0U7Ci0JCQkJ
CWVsc2UKLQkJCQkJCW1lbWNweShlYV92YWx1ZSwgcGFjbCwgYWNsbGVuKTsKLQkJCQl9Ci0JCQkJ
cmMgPSBhY2xsZW47Ci0JCQkJa2ZyZWUocGFjbCk7CisJCXUzMiBhY2xsZW47CisJCXN0cnVjdCBj
aWZzX250c2QgKnBhY2w7CisKKwkJaWYgKHBUY29uLT5zZXMtPnNlcnZlci0+b3BzLT5nZXRfYWNs
ID09IE5VTEwpCisJCQlnb3RvIGdldF9lYV9leGl0OyAvKiByYyBhbHJlYWR5IEVPUE5PVFNVUFAg
Ki8KKworCQlwYWNsID0gcFRjb24tPnNlcy0+c2VydmVyLT5vcHMtPmdldF9hY2woY2lmc19zYiwK
KwkJCQlkX2lub2RlKGRpcmVudHJ5KSwgZnVsbF9wYXRoLCAmYWNsbGVuKTsKKwkJaWYgKElTX0VS
UihwYWNsKSkgeworCQkJcmMgPSBQVFJfRVJSKHBhY2wpOworCQkJY2lmc19kYmcoVkZTLCAiJXM6
IGVycm9yICV6ZCBnZXR0aW5nIHNlYyBkZXNjXG4iLAorCQkJCSBfX2Z1bmNfXywgcmMpOworCQl9
IGVsc2UgeworCQkJaWYgKGVhX3ZhbHVlKSB7CisJCQkJaWYgKGFjbGxlbiA+IGJ1Zl9zaXplKQor
CQkJCQlhY2xsZW4gPSAtRVJBTkdFOworCQkJCWVsc2UKKwkJCQkJbWVtY3B5KGVhX3ZhbHVlLCBw
YWNsLCBhY2xsZW4pOwogCQkJfQorCQkJcmMgPSBhY2xsZW47CisJCQlrZnJlZShwYWNsKTsKKwkJ
fQogI2Vsc2UKLQkJCWNpZnNfZGJnKEZZSSwgIlF1ZXJ5IENJRlMgQUNMIG5vdCBzdXBwb3J0ZWQg
eWV0XG4iKTsKKwkJY2lmc19kYmcoRllJLCAiUXVlcnkgQ0lGUyBBQ0wgbm90IHN1cHBvcnRlZCB5
ZXRcbiIpOwogI2VuZGlmIC8qIENPTkZJR19DSUZTX0FDTCAqLwogCX0gZWxzZSBpZiAoc3RybmNt
cChlYV9uYW1lLAogCQkgIFhBVFRSX1RSVVNURURfUFJFRklYLCBYQVRUUl9UUlVTVEVEX1BSRUZJ
WF9MRU4pID09IDApIHsKLS0gCjEuOS4xCgo=
--f46d04289bc92ff30505306a521c--
