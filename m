From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: Re: [PATCH] cifs: cifssmb: Fix potential NULL pointer dereference
Date: Tue, 3 Apr 2018 16:02:20 -0500
Message-ID: <a0bbcf88-37c9-0a73-02ae-6ec63f94484b@embeddedor.com>
References: <20180403205512.GA28804@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <sfrench@samba.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180403205512.GA28804@embeddedor.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Hi,

I noticed the subject was incorrect. Drop this patch, please.

I just sent v2.

Thanks
--
Gustavo

On 04/03/2018 03:55 PM, Gustavo A. R. Silva wrote:
> tcon->ses is being dereferenced before it is null checked, hence
> there is a potential null pointer dereference.
> 
> Fix this by moving the pointer dereference after tcon->ses has
> been properly null checked.
> 
> Addresses-Coverity-ID: 1467426 ("Dereference before null check")
> Fixes: 93012bf98416 ("cifs: add server->vals->header_preamble_size")
> Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
> ---
>   fs/cifs/smb2pdu.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index f7741ce..e5ac474 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -3454,7 +3454,7 @@ static int
>   build_qfs_info_req(struct kvec *iov, struct cifs_tcon *tcon, int level,
>   		   int outbuf_len, u64 persistent_fid, u64 volatile_fid)
>   {
> -	struct TCP_Server_Info *server = tcon->ses->server;
> +	struct TCP_Server_Info *server;
>   	int rc;
>   	struct smb2_query_info_req *req;
>   	unsigned int total_len;
> @@ -3464,6 +3464,8 @@ build_qfs_info_req(struct kvec *iov, struct cifs_tcon *tcon, int level,
>   	if ((tcon->ses == NULL) || (tcon->ses->server == NULL))
>   		return -EIO;
>   
> +	server = tcon->ses->server;
> +
>   	rc = smb2_plain_req_init(SMB2_QUERY_INFO, tcon, (void **) &req,
>   			     &total_len);
>   	if (rc)
> 
