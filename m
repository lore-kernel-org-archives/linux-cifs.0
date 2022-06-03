Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21A55C43334
	for <linux-cifs@archiver.kernel.org>; Fri,  3 Jun 2022 00:11:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239432AbiFCALR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 2 Jun 2022 20:11:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbiFCALO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 2 Jun 2022 20:11:14 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CCBD1D33B;
        Thu,  2 Jun 2022 17:11:11 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 252KdEQg003281;
        Fri, 3 Jun 2022 00:10:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=ryt858/KNUWV1rDF8egG9R+Te6TmrV7ek8njqxVpziI=;
 b=DseaV8lXoe3Sr74iMgW28ARQxmLfzPsSE8img4DFK4YWMT0gx6FTuiAGrVKE/8hLV7QU
 /vNURRefLLF6dI0Dyp6aQKD9pzsNTrDpOPa8dfwqPTBFeGIpRvPoFzgCejF7VqL4Ala+
 /eb/r58kYJhnyfT80ibyUA/eY+UFcFUveQJpgzyN0ZaA5XfM0jFxzUZ+tKWVa67ZhWju
 K85x7R6LmnvD/PYfuVhm674IbZQHFLwas1VZCumViBnCMVciiUpxnVMaIyKpb7fP+Y1H
 8iUdPrDNIfrqmlp0N22s3r73gL0EdbLe663FbjGFLPGAjnoWUb+54fi3gjh9bJ21D3W2 Og== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gbc6xbqcq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jun 2022 00:10:44 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2530ADwd010660;
        Fri, 3 Jun 2022 00:10:43 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gc8p5e0kd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jun 2022 00:10:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F+dHYkraOz1pSyFVXJysaVMoXYmiZxfsPgvMi+aW2bab9snHaCTqLoXAor2cUNxT58Mihgmq7OPeVxOxPZBsI14VBOdMam3uaL+XPBQgSP97dPNJfaCkxmlVJ7dPGl7FO9xSBXmg5zohnrI9vyw7XpWDPHIZ7Cii1u7tebHRC8b0D6IOFI3jaEzsIolt9eFYuN9ILil08M/ucYQiJNTnr3A5OdQV8YbOfvmlTerS3PXUV4Igp0pYKKImoAft4GTp8J2VufNWDBRusfmxvxTRkpHFYFLIrhj5G0prrHVGMeaIcM09A4ENuKYg8JM7nxWlAcORq51hSY92KIgCIditrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ryt858/KNUWV1rDF8egG9R+Te6TmrV7ek8njqxVpziI=;
 b=eLWR9zCttBih9WdoA//tv6AlsMAp0Ps8JahP7XucEAEgWwIHahfDdwWuTZ3EVQ7ArKO2atvTShKCUhdjKdNmKzP/N8PFLeZ3+WAnzHTU1q9Ma4r0aiJcGGFYqd3wvqtHfvgKtkrgEQ9ikSnBo5fpXW3jy29Z3Tzxui1Cx3PzfRLjWvSCXGwSg8HR/17OdGhzewD8YxFfyVP1DhpMv9ei7O/1AgxD7UFAxW5G8zeX3bX8SjpJhv++kTNdWda97av3ArSldfvj/bfFFvZeLjziUmWLRKux7kzkcSAckDUY8hEf0++iEBIBEI60QUU9n2xRojk81V+v0A9dTq/YIjBjSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ryt858/KNUWV1rDF8egG9R+Te6TmrV7ek8njqxVpziI=;
 b=du92UZmhkgWBLnEfSZ6elFlBYxUHVR0WTSxCBH2fCxnHjbVLO5ehnc5qYFR6bvLwKlxyxVuquaJHBbxOPccqbQdUm3fo5C7+SS4Cmq9P/dsWyPAoAa9FBJORjHnxJe6QLwnHOLPNw9sO5FYEZ1OoJZ0BJY5wpw0rB3xd+P+iUIk=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CH2PR10MB4054.namprd10.prod.outlook.com
 (2603:10b6:610:3::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.15; Fri, 3 Jun
 2022 00:10:41 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::86f:81ba:9951:5a7e]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::86f:81ba:9951:5a7e%2]) with mapi id 15.20.5293.019; Fri, 3 Jun 2022
 00:10:41 +0000
Date:   Fri, 3 Jun 2022 03:10:21 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     Steve French <sfrench@samba.org>, Hyunchul Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        linux-cifs@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] ksmbd: clean up a type in ksmbd_vfs_stream_write()
Message-ID: <20220603001021.GL2168@kadam>
References: <YpiWS/WQr2qMidvA@kili>
 <CAKYAXd_=x-uT8U_2tdbmVxbhyg_pDY03NKP9zzDwQZmm0TxQmg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKYAXd_=x-uT8U_2tdbmVxbhyg_pDY03NKP9zzDwQZmm0TxQmg@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0018.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4c::23)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7fc81aec-ad05-4a78-eb63-08da44f57e28
X-MS-TrafficTypeDiagnostic: CH2PR10MB4054:EE_
X-Microsoft-Antispam-PRVS: <CH2PR10MB40540E31562DDE5CCF501AC08EA19@CH2PR10MB4054.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uUt6OghcA+PRlTC8N2slp3UAnPHTg+maqGe60SmaRgvazKYpiA9vJ7enc18GqZsNUI7HLxQYjKtpicpBv7EQx+Vxw6Oz/d6lr2INGMhc0ZqiR0kcd9BpJJzzIkoLxlKC2pDuAmGyciOxnPYjvwGXZk53K/AnWsoJZze5wFB97+QND3wT/xCL0DXk0XfQmMqeN6pmMQLT9cG7IgvN9BNUCE14UMIlhNYhyayR3FJmItitQo/imjCm+yhQ0EAAOUJl2TOQ6i+9bsJ6hSRLkY5b/n3pZhQj5h7eY+lC5MOIgXn/hBuJtBLFD2aWW/szMOhHklfyZlKTuiobYvghzryWAYtPheAvELte1e8+oS5EG4Oi4MFokxsTvd5eCQ/NDAZOp0WyETJ7tUh23idFiQW8U030dDPdXDvyTHjr2iTIdYBxe/laszyGki3LhpLwv1Kz1337X1fEHMo2q6rW80UpRJbYTkoSKXxP1xRuQO0MfogRU22+hfECSxYsDoweW6VIq3IDpWTM5l2A947JGNbCzAFHqDcnb02BC8dqM58jYYp6BX20cRkrzsVdPoEPeClU9AVCpyyFPX+T+Tc4b9ZC1XtOdaehJY1GmDHYsVDLyA5eifq9fzY7qBNPQAhOTPW7sqn1ysr2QRnVwtufJEEIecB0/TisTSv+cX4vtCvG4QgmqbaWGxU3ChxaHveGPxRSnHdKzmwC3lKrWZ0DcByEEQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(9686003)(5660300002)(4326008)(6506007)(8676002)(4744005)(2906002)(38100700002)(66476007)(66946007)(6666004)(66556008)(6512007)(52116002)(44832011)(33716001)(6486002)(8936002)(508600001)(6916009)(26005)(316002)(86362001)(54906003)(186003)(33656002)(1076003)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?e4YeAbKffZGGHGiRlG6ZtQ0MD8fV5VynaEU8cqusnu7nn89FTMt4Sij8Pdkv?=
 =?us-ascii?Q?IK0cDfT4Leok4Rc/jLuM5ij1g+rD3rGVCB2SMfkzQuz+IxkXI75VHETw+Fi5?=
 =?us-ascii?Q?JHSqelGsNk6aWziHE8+hkR7L7dnRadGxnsFxkZlEFK7AgezKBCTzYaRxA0SY?=
 =?us-ascii?Q?9MVYgLTeYsLV5mTKTxYroynztkEK0y97AP5V2dH7cSUElXdw9iUSU5bbQVoi?=
 =?us-ascii?Q?vp4qlLTv+mjWxCHIK1AK/eJLmn6+VBlpx8p3r5h+ta5ZzBQn/jmQxmqeafCu?=
 =?us-ascii?Q?DjogzKwP6Dw+mdGZzEGmWuVTBPY47c8tUCqDXhgC8S02b4oQekkDxptxUOEP?=
 =?us-ascii?Q?alkV2ssnmN6prVHXbzEXtXsXGm2Na84JGXNha3d5KS86jIBy4GQJxFttjbGx?=
 =?us-ascii?Q?aRUiz/h+zImxtKHvHUu5clbI2VLbLkKcYgCEV5fVyPqudSPg8dDMHCK/2kHF?=
 =?us-ascii?Q?8xZQNNo5FZ2OEOoIZvgYcbotDs1lxMDIq99DBN//+iNJc6e012G5XW7odRxr?=
 =?us-ascii?Q?Nvcf7KeuEoyl1GddY/ENubmDBsShG4+mwdYfextznkslQnrjwpxdCSsj+hpx?=
 =?us-ascii?Q?wv5WJkt+5iJjcZ4Ku8bO3eS8R4j0W0UCrNtpNpP5LOPw6NzJUCWibMYWJNx7?=
 =?us-ascii?Q?FiDS7eOMHw+hR7XhkxSA5AZvbVtcSjpD4D8DacoemWwsK7fG3IGqDsd5zuxq?=
 =?us-ascii?Q?d07hVyyZwMqdeDghnFMnugzyXMBOHJuXkBF69N9hvLwVRkRD9hEfRnJbLCBy?=
 =?us-ascii?Q?6seGQFgZHos/fpmyRhmvCuTZmDnfQHKbue2bItIgIy8YjuYnNgfwsnJAg539?=
 =?us-ascii?Q?xq4ZsqyAB3baN6+HdHP0VuK3Dpam4zWXxnw0XhLCsC2t5MLfHnrsfS06o2C+?=
 =?us-ascii?Q?riTqkAXg676/uU8uyGUnmlmp59QIE22Uft2PeeKKvTsTpVSpMi2AmgI3Cvqk?=
 =?us-ascii?Q?k3x7XAZQ8YSuSxC5WvyZA1kNW/D5GYiE23BlUrsVeH6dKM4fBSUboDkk+sn5?=
 =?us-ascii?Q?iWglv/nJwrgQ/JfQK5TIVSc/kUtWNoHo+XHtTBqLllieadde1pg8Z74PPYxe?=
 =?us-ascii?Q?Fv8kjTp1wEGJLUKQy1dhbdi33fvIp3MRPRn68Pg8QvrqhxRl2HqVyb2kE+Hh?=
 =?us-ascii?Q?d2oCiwIWbBdsH8oJ3F8swI+ZLlCDpE4Dhnan4cLPJ5IIKjJo3xAKgrq6CEFM?=
 =?us-ascii?Q?aujTVPJbxK62q0mjd8tXUtgYiZWOS7OV1uExViNQZ2lUq/lJUEk9O/Gse3Wy?=
 =?us-ascii?Q?W9k1U605zYhEwuq038PKGknF3Kwk7rRylYxserZb9kjeXqS9/K63BaQP74XU?=
 =?us-ascii?Q?E5M2TE7JjVPOaCqf+hzxFYdbIUVrcWFXYhX3919P0LBB6yLyOjS1+z/vWLbK?=
 =?us-ascii?Q?u1urV+n6JRLlSxqiwuYZKWgl3NdpcDV7KHXG86tKT+OL00lw2s54TR0EK8a/?=
 =?us-ascii?Q?eMhmo3z1IUsYKd6/Yq9lqsGEgM5J7Ago6AmJRTq4VAg6Cy7B4P0xJUvWqVwu?=
 =?us-ascii?Q?QhHZ3/4foYUAVcHAMCMYDNsonX4y2g4E2yTWwxp1ubeflv0KDBxbCogxafnL?=
 =?us-ascii?Q?S9RjkrRPnZmW4DNb5sHsaftnaz9VGTB3ywlS5WsoVU/WeL6bIi7Al8JXyFPV?=
 =?us-ascii?Q?5MPDj7gy0OD08wxKbzMirTS4Ns+SAwgIUHKD2EOpyrjYd4MSm8XGkHllGWl7?=
 =?us-ascii?Q?qIPMj8iYXPJbSKcZgIGlVfU3mYEH8l+HpagvysGPE/HTWuCoOwG6La8FBJYn?=
 =?us-ascii?Q?yJFa52BmmDmSax/i4/y0gA3nOjZCBEs=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fc81aec-ad05-4a78-eb63-08da44f57e28
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2022 00:10:40.9226
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hYpcPyAWq6KNt4fPDZpECVWU5ncPDwZH22z0ycv4jY6TRysRNRCc8tSZUrUEPiDRhi2BUx3uMH4uCqAE3oSogoc9YwA1h/hSvUKVMM9ptBw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4054
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-02_06:2022-06-02,2022-06-02 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206020100
X-Proofpoint-GUID: YteTEXY59KOqDRl5U7fE0WCDAdwIKcx_
X-Proofpoint-ORIG-GUID: YteTEXY59KOqDRl5U7fE0WCDAdwIKcx_
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Jun 03, 2022 at 08:18:19AM +0900, Namjae Jeon wrote:
> 2022-06-02 19:51 GMT+09:00, Dan Carpenter <dan.carpenter@oracle.com>:
> > @@ -428,9 +429,9 @@ static int ksmbd_vfs_stream_write(struct ksmbd_file *fp,
> > char *buf, loff_t *pos,
> >  				       fp->stream.name,
> >  				       fp->stream.size,
> >  				       &stream_buf);
> > -	if ((int)v_len < 0) {
> > +	if (v_len < 0) {
> >  		pr_err("not found stream in xattr : %zd\n", v_len);
> > -		err = (int)v_len;
> > +		err = v_len;
> Data type of ssize_t is long. Wouldn't some static checker warn us
> that this is a problem?

None that I know of.

To a human reader, the cast isn't needed because when a function returns
ssize_t the negatives can only be error codes in the (-4095)-(-1) range.
No other negative sizes make sense.

On the other hand, the "if ((int)v_len < 0) {" line really should
trigger a static checker because there are times when sizes could be
over 2GB.  I will write down that I need to create that checker.

regards,
dan carpenter

