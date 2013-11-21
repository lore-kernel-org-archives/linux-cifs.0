From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: posix remove acl support
Date: Wed, 20 Nov 2013 23:04:57 -0600
Message-ID: <CAH2r5mvcidQk7C47ZSFLPZ0yaU2yzzAabWDK2f19VMxBi3NzTg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=047d7bdca8f0d304db04eba8d67d
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--047d7bdca8f0d304db04eba8d67d
Content-Type: text/plain; charset=ISO-8859-1

Jeremy,
As you noted we need to add support to cifs kernel client to remove POSIX ACLs.

This patch is close (it seems to work, but wireshark did not like the
buffer lengths when I did a setfacl -k although setacl -b looked fine.

It works basically by passing the minimum size in for the ACL (0
entries) - sending a zero in the number of ACEs removes the entry.

Comments/feedback?

diff --git a/fs/cifs/xattr.c b/fs/cifs/xattr.c
index 09afda4..c301651 100644
--- a/fs/cifs/xattr.c
+++ b/fs/cifs/xattr.c
@@ -69,6 +69,33 @@ int cifs_removexattr(struct dentry *direntry, const
char *ea_name)
  }
  if (ea_name == NULL) {
  cifs_dbg(FYI, "Null xattr names not supported\n");
+
+#ifdef CONFIG_CIFS_POSIX
+ } else if (strncmp(ea_name, POSIX_ACL_XATTR_ACCESS,
+   strlen(POSIX_ACL_XATTR_ACCESS)) == 0) {
+ if (sb->s_flags & MS_POSIXACL) {
+ posix_acl_xattr_header acl;
+ acl.a_version = cpu_to_le32(2);
+ rc = CIFSSMBSetPosixACL(xid, pTcon, full_path,
+ (const char *)&acl,
+ 4 /* min struct posix_acl_xattr_header */,
+ ACL_TYPE_ACCESS, cifs_sb->local_nls,
+ cifs_sb->mnt_cifs_flags &
+ CIFS_MOUNT_MAP_SPECIAL_CHR);
+ cifs_dbg(VFS, "set POSIX ACL rc %d\n", rc); /* BB FIXME BB */
+ }
+ } else if (strncmp(ea_name, POSIX_ACL_XATTR_DEFAULT,
+   strlen(POSIX_ACL_XATTR_DEFAULT)) == 0) {
+ if (sb->s_flags & MS_POSIXACL) {
+ posix_acl_xattr_header acl;
+ acl.a_version = cpu_to_le32(2);
+ rc = CIFSSMBSetPosixACL(xid, pTcon, full_path,
+ (const char *)&acl, 4, ACL_TYPE_DEFAULT,
+ cifs_sb->local_nls, cifs_sb->mnt_cifs_flags &
+ CIFS_MOUNT_MAP_SPECIAL_CHR);
+ cifs_dbg(VFS, "set POSIX default ACL rc %d\n", rc); /* BB FIXME BB */
+ }
+#endif /* CONFIG_CIFS_POSIX */
  } else if (strncmp(ea_name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN)
  && (strncmp(ea_name, XATTR_OS2_PREFIX, XATTR_OS2_PREFIX_LEN))) {
  cifs_dbg(FYI,

-- 
Thanks,

Steve

--047d7bdca8f0d304db04eba8d67d
Content-Type: text/x-patch; charset=US-ASCII; name="posix-acl-remove-support.patch"
Content-Disposition: attachment; filename="posix-acl-remove-support.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ho9jc5pe0

ZGlmZiAtLWdpdCBhL2ZzL2NpZnMveGF0dHIuYyBiL2ZzL2NpZnMveGF0dHIuYwppbmRleCAwOWFm
ZGE0Li5jMzAxNjUxIDEwMDY0NAotLS0gYS9mcy9jaWZzL3hhdHRyLmMKKysrIGIvZnMvY2lmcy94
YXR0ci5jCkBAIC02OSw2ICs2OSwzMyBAQCBpbnQgY2lmc19yZW1vdmV4YXR0cihzdHJ1Y3QgZGVu
dHJ5ICpkaXJlbnRyeSwgY29uc3QgY2hhciAqZWFfbmFtZSkKIAl9CiAJaWYgKGVhX25hbWUgPT0g
TlVMTCkgewogCQljaWZzX2RiZyhGWUksICJOdWxsIHhhdHRyIG5hbWVzIG5vdCBzdXBwb3J0ZWRc
biIpOworCisjaWZkZWYgQ09ORklHX0NJRlNfUE9TSVgJCQorCX0gZWxzZSBpZiAoc3RybmNtcChl
YV9uYW1lLCBQT1NJWF9BQ0xfWEFUVFJfQUNDRVNTLAorCQkJCSAgIHN0cmxlbihQT1NJWF9BQ0xf
WEFUVFJfQUNDRVNTKSkgPT0gMCkgeworCQlpZiAoc2ItPnNfZmxhZ3MgJiBNU19QT1NJWEFDTCkg
eworCQkJcG9zaXhfYWNsX3hhdHRyX2hlYWRlciBhY2w7CisJCQlhY2wuYV92ZXJzaW9uID0gY3B1
X3RvX2xlMzIoMik7CisJCQlyYyA9IENJRlNTTUJTZXRQb3NpeEFDTCh4aWQsIHBUY29uLCBmdWxs
X3BhdGgsCisJCQkJKGNvbnN0IGNoYXIgKikmYWNsLAorCQkJCTQgLyogbWluIHN0cnVjdCBwb3Np
eF9hY2xfeGF0dHJfaGVhZGVyICovLAorCQkJCUFDTF9UWVBFX0FDQ0VTUywgY2lmc19zYi0+bG9j
YWxfbmxzLAorCQkJCWNpZnNfc2ItPm1udF9jaWZzX2ZsYWdzICYKKwkJCQkJQ0lGU19NT1VOVF9N
QVBfU1BFQ0lBTF9DSFIpOworCQkJY2lmc19kYmcoVkZTLCAic2V0IFBPU0lYIEFDTCByYyAlZFxu
IiwgcmMpOyAvKiBCQiBGSVhNRSBCQiAqLworCQl9CisJfSBlbHNlIGlmIChzdHJuY21wKGVhX25h
bWUsIFBPU0lYX0FDTF9YQVRUUl9ERUZBVUxULAorCQkJCSAgIHN0cmxlbihQT1NJWF9BQ0xfWEFU
VFJfREVGQVVMVCkpID09IDApIHsKKwkJaWYgKHNiLT5zX2ZsYWdzICYgTVNfUE9TSVhBQ0wpIHsK
KwkJCXBvc2l4X2FjbF94YXR0cl9oZWFkZXIgYWNsOworCQkJYWNsLmFfdmVyc2lvbiA9IGNwdV90
b19sZTMyKDIpOworCQkJcmMgPSBDSUZTU01CU2V0UG9zaXhBQ0woeGlkLCBwVGNvbiwgZnVsbF9w
YXRoLAorCQkJCShjb25zdCBjaGFyICopJmFjbCwgNCwgQUNMX1RZUEVfREVGQVVMVCwKKwkJCQlj
aWZzX3NiLT5sb2NhbF9ubHMsIGNpZnNfc2ItPm1udF9jaWZzX2ZsYWdzICYKKwkJCQkJQ0lGU19N
T1VOVF9NQVBfU1BFQ0lBTF9DSFIpOworCQkJY2lmc19kYmcoVkZTLCAic2V0IFBPU0lYIGRlZmF1
bHQgQUNMIHJjICVkXG4iLCByYyk7IC8qIEJCIEZJWE1FIEJCICovCisJCX0KKyNlbmRpZiAvKiBD
T05GSUdfQ0lGU19QT1NJWCAqLwogCX0gZWxzZSBpZiAoc3RybmNtcChlYV9uYW1lLCBYQVRUUl9V
U0VSX1BSRUZJWCwgWEFUVFJfVVNFUl9QUkVGSVhfTEVOKQogCQkmJiAoc3RybmNtcChlYV9uYW1l
LCBYQVRUUl9PUzJfUFJFRklYLCBYQVRUUl9PUzJfUFJFRklYX0xFTikpKSB7CiAJCWNpZnNfZGJn
KEZZSSwK
--047d7bdca8f0d304db04eba8d67d--
