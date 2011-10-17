From: Gerlando Falauto <gerlando.falauto-SkAbAL50j+5BDgjK7y7TUQ@public.gmane.org>
Subject: mount.cifs on Win2k8 DFS servers
Date: Mon, 17 Oct 2011 13:58:46 +0200
Message-ID: <4E9C1876.5090205@keymile.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: 7bit
Cc: gerlando.falauto-SkAbAL50j+5BDgjK7y7TUQ@public.gmane.org
To: samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

my CIFS kernel module (linux 2.6.39.3) fails to mount DFS trees from 
Win2k8 servers.

Whereas upon "Tree Connect AndX Request"s (for a DFS tree) Win2k3 used 
to reply with STATUS_PATH_NOT_COVERED, Win2k8 now answers with 
STATUS_BAD_NETWORK_NAME, pretty much the same thing it would say about a 
non-existing share.

This is somewhat related to:
https://bugzilla.samba.org/show_bug.cgi?id=8003
but in fact only affects cifs-fs and NOT smbclient which works fine for me.

In fact, Windows machines (and smbclient, for that matter) don't ever 
try connecting the tree, as they both start off with a "Trans2 Request" 
GET_DFS_REFERRAL.

Excerpt from source3/libsmb/clidfs.c:
=== CUT ===
     /* here's the fun part....to support 'msdfs proxy' shares
       (on Samba or windows) we have to issues a TRANS_GET_DFS_REFERRAL
        here before trying to connect to the original share.
        cli_check_msdfs_proxy() will fail if it is a normal share. */

     if ((cli_state_capabilities(c) & CAP_DFS) &&
=== CUT ===

Now, I came up with a workaround (which I would not post here in order 
not to be yelled at...) for cifs-fs which simply treats 
NT_STATUS_BAD_NETWORK_NAME as NT_STATUS_PATH_NOT_COVERED, but I guess we 
need a better solution.

What should be the be best approach for facing this?
Detecting the server has DFS capabilities and start getting DFS 
referrals to begin with?
Has this been discussed in the past? I find it hard to believe that no 
one has reported this problem before...

Thanks!
Gerlando
