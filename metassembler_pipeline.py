#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pandas as pd
import os
import sys, getopt
import argparse


# In[32]:


read1 = sys.argv[1]
read2 = sys.argv[2]
#read1 = "J10_S9_L001_R1_001.fastq"
#read2 = "J10_S9_L001_R2_001.fastq"


# In[9]:


#runing quast
os.system("quast *.fasta -o quast_out")
#creating metassembler output folder
os.system("mkdir metassembler_out")


# In[13]:


#getting quast results
quast = pd.read_table("quast_out/transposed_report.tsv")
quast.sort_values(by="N50", ascending=False,inplace=True)


# In[26]:


print("The file order by N50 is: ", [x+".fasta" for x in quast["Assembly"].values.tolist()])


# In[33]:


#generating fixed part of file
variable_list = [["[global]\n"],["bowtie2_read1="+read1+"\n"], ["bowtie2_read2="+read2+"\n"], ["bowtie2_minins=100"+"\n"+ 
               "bowtie2_maxins=1000"+"\n"+
               "bowtie2_threads=16"+"\n"+
               "mateAn_m=500"+"\n"+
               "mateAn_s=250"+"\n"]]


# In[34]:


#concatenating with variable part of file
assembly_count = 1
genomes = quast["Assembly"].values.tolist()
for assembly in range(0, len(genomes)):
    #print(assembly_count, genomes[assembly]+".fasta")
    variable_list.append(["["+str(assembly_count)+"]\n","fasta="+genomes[assembly]+".fasta\n","ID="+genomes[assembly]+"\n"])
    assembly_count+=1
#print(variable_list)


# In[36]:


#generating metassembler config file
with open("metassembler_out/metassembler-config.txt", "w") as meta:
    for m in variable_list:
        for _string in m:
            meta.write(_string)


# In[24]:


print("Metassembler file done")


# In[ ]:




