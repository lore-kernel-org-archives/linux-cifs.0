From: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Subject: linux-next: build failure after merge of the cifs tree
Date: Tue, 26 Sep 2017 10:51:48 +1000
Message-ID: <20170926105148.5e1553ec@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Linux-Next Mailing List <linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        CIFS <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi all,

After merging the cifs tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

fs/cifs/smb2transport.c: In function 'generate_smb311signingkey':
fs/cifs/smb2transport.c:403:27: error: 'struct cifs_ses' has no member named 'preauth_sha_hash'
  d->context.iov_base = ses->preauth_sha_hash;
                           ^
fs/cifs/smb2transport.c:409:27: error: 'struct cifs_ses' has no member named 'preauth_sha_hash' 
  d->context.iov_base = ses->preauth_sha_hash;
                           ^
fs/cifs/smb2transport.c:415:27: error: 'struct cifs_ses' has no member named 'preauth_sha_hash' 
  d->context.iov_base = ses->preauth_sha_hash;
                           ^

Caused by commit

  a679c0e328c9 ("Fix encryption labels and lengths for SMB3.1.1")

This build has

# CONFIG_CIFS_SMB311 is not set

I have used the version of the cifs tree from next-20170922 for today.

-- 
Cheers,
Stephen Rothwell
