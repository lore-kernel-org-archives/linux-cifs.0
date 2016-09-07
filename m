From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] Fix regression which breaks DFS mounting
Date: Wed, 07 Sep 2016 10:02:55 +0100
Message-ID: <1473238975.3882.39.camel@redhat.com>
References: <1473164554-8062-1-git-send-email-sprabhu@redhat.com>
         <mps1t0wswyh.fsf@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
To: =?ISO-8859-1?Q?Aur=E9lien?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>,
        linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <mps1t0wswyh.fsf-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 2016-09-06 at 20:29 +0200, Aurélien Aptel wrote:
> This is not enough to fix DFS. I believe we also need [1] to handle
> DFS
> links to subdirs.
> 
> I have SERVER_A with a DFS link to //SERVER_B/sub/dir.
> cifs_are_all_path_accessible() and cifs_get_root() walk along the
> path
> components and do queries on them. But they are not skipping the
> initial
> host + share name on the UNC resulting in failed queries:
> 
>   CLIENT_A_____ -> SERVER_B____ SMB Trans2 Request,
>       QUERY_PATH_INFO, Query File All Info, Path: //SERVER_B____
>   SERVER_B____ -> CLIENT_A_____ SMB Trans2 Response,
>       QUERY_PATH_INFO, Error: STATUS_OBJECT_NAME_NOT_FOUND
> 
> The QUERY_PATH_INFO request here is using the first path component
> which
> is not a file path but an incomplete UNC path.
> 
> That path is made by cifs_build_path_to_root() which only makes a
> full
> UNC path when in a DFS. It is not necessary on the servers I've
> tested
> (cf [1]).
> 
> Therefore the fix is to not make a full UNC path in
> cifs_build_path_to_root() or to add a flag to its parameters to
> decide
> whether to prefix the host+share or not. I've sent patches for both
> solution on the thread [1] (look at all the messages of the thread).
> 
> 1: http://marc.info/?i=20160801143204.7377b5a4@aaptelpc
> 

Hello Auriel,

I have encountered a similar problem reported by a user a few days ago
when mounting a DFS share hosted on a Netapp. 

The problem is caused when 
1) The flag SMB_SHARE_IS_IN_DFS is set in the optional flags when a
tcon connect is returned.
2) The subsequent Trans2 request with QUERY_PATH_INFO doesn't return a
STATUS_PATH_NOT_COVERED which indicates that this is a DFS share and we
need to call a GET_DFS_REFERRAL to obtain the DFS node to connect to.

This is hit in Netapp because it returns SMB_SHARE_IS_IN_DFS even after
the DFS node is resolved and the node returned doesn't contain a DFS
share. Other servers(tested with MS Win2012 R2) do not and hence do not
face this problem. A workaround for Netapp servers is to mount with the
nodfs flag.

I have a patch similar to your second variant which we have
successfully tested in our lab and is currently undergoing user
testing. I'll post it separately as soon as we have the results for
that.

In my opinion, the patch at the head of the thread here is not related
to this problem and should go in ASAP to fix a regression which affects
all DFS mounts.

Sachin Prabhu
